import AVFoundation
import Foundation
import OSLog
import SwiftData

/// Runs transcription jobs in the background, detached from any view's
/// lifetime, so the note is saved immediately and the transcript fills in
/// when ready. Also powers the "Retry transcription" action on failed notes
/// and rescues work interrupted by a crash.
@MainActor
final class TranscriptionWorker: ObservableObject {
    static let shared = TranscriptionWorker()

    /// Notes currently being transcribed, so views can show progress and
    /// duplicate jobs are ignored.
    @Published private(set) var activeNoteIDs: Set<UUID> = []

    private let log = Logger(subsystem: "com.brew.app", category: "transcription")

    func transcribe(note: Note, fileURL: URL, locale: Locale, context: ModelContext) {
        guard !activeNoteIDs.contains(note.id) else { return }
        activeNoteIDs.insert(note.id)
        note.status = .transcribing
        note.transcriptionErrorMessage = nil
        save(context)

        Task {
            do {
                let transcript = try await SpeechTranscriber.transcribe(fileURL: fileURL, locale: locale)
                guard !note.isDeleted else { activeNoteIDs.remove(note.id); return }
                note.transcript = transcript.trimmingCharacters(in: .whitespacesAndNewlines)
                note.status = .transcribed
                log.info("Transcribed note \(note.id, privacy: .public): \(note.transcript.count) chars")
            } catch {
                guard !note.isDeleted else { activeNoteIDs.remove(note.id); return }
                note.status = .transcriptionFailed
                note.transcriptionErrorMessage = error.localizedDescription
                log.error("Transcription failed for note \(note.id, privacy: .public): \(error.localizedDescription, privacy: .public)")
            }
            activeNoteIDs.remove(note.id)
            save(context)
        }
    }

    /// Re-runs transcription against the retained audio file, in the language
    /// the recording was made with (falling back to the current preference).
    func retry(note: Note, context: ModelContext) {
        guard let fileName = note.audioFileName else {
            note.transcriptionErrorMessage = TranscriptionError.audioFileMissing.localizedDescription
            note.status = .transcriptionFailed
            save(context)
            return
        }
        let url = Self.documentsURL.appendingPathComponent(fileName)
        let language = note.languageRaw.flatMap(TranscriptionLanguage.init(rawValue:))
            ?? TranscriptionLanguage.preferred
        transcribe(note: note, fileURL: url, locale: language.locale, context: context)
    }

    /// Rescues work interrupted by a crash or app kill:
    /// - Notes stuck in `.transcribing` (the background task died) are retried.
    /// - Notes stuck in `.enhancing` with no AI note revert to `.transcribed`
    ///   so the detail screen's auto-generate picks them up again.
    /// - Audio files in Documents that no note references become
    ///   "Recovered recording" notes and are transcribed.
    func recoverInterruptedWork(context: ModelContext) async {
        let notes = (try? context.fetch(FetchDescriptor<Note>())) ?? []

        for note in notes where note.status == .transcribing && !activeNoteIDs.contains(note.id) {
            log.info("Resuming interrupted transcription for note \(note.id, privacy: .public)")
            retry(note: note, context: context)
        }
        for note in notes where note.status == .enhancing && (note.enhancedNote?.isEmpty ?? true) {
            note.status = .transcribed
        }

        // File enumeration and audio-header reads happen off the main actor.
        let referenced = Set(notes.compactMap(\.audioFileName))
        let docsURL = Self.documentsURL
        let orphans: [(fileName: String, durationSeconds: Int)] = await Task.detached(priority: .utility) {
            let fm = FileManager.default
            guard let files = try? fm.contentsOfDirectory(at: docsURL, includingPropertiesForKeys: nil) else { return [] }
            var found: [(String, Int)] = []
            for url in files where url.lastPathComponent.hasPrefix("rec-") && url.pathExtension == "caf" {
                guard !referenced.contains(url.lastPathComponent) else { continue }
                guard let audio = try? AVAudioFile(forReading: url), audio.fileFormat.sampleRate > 0 else { continue }
                let duration = Double(audio.length) / audio.fileFormat.sampleRate
                guard duration >= 1 else {
                    try? fm.removeItem(at: url) // too short to matter; clean up
                    continue
                }
                found.append((url.lastPathComponent, Int(duration)))
            }
            return found
        }.value

        for orphan in orphans {
            let note = Note(
                title: "Recovered recording",
                durationSeconds: orphan.durationSeconds,
                audioFileName: orphan.fileName,
                transcript: "",
                status: .transcriptionFailed
            )
            context.insert(note)
            log.info("Recovered orphaned recording \(orphan.fileName, privacy: .public)")
            retry(note: note, context: context)
        }
        save(context)
    }

    static var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func save(_ context: ModelContext) {
        do { try context.save() } catch {
            log.error("Failed to save note: \(error.localizedDescription, privacy: .public)")
        }
    }
}
