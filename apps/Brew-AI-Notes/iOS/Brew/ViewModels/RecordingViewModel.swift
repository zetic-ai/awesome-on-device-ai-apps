import AVFoundation
import Foundation
import SwiftData

/// Drives a recording session: records microphone audio to a file, tracks
/// elapsed time and input level, and on stop transcribes the whole recording
/// into a Note.
@MainActor
final class RecordingViewModel: ObservableObject {
    @Published var elapsed: TimeInterval = 0
    @Published var isPaused = false
    @Published var level: Float = 0
    @Published var permissionDenied = false
    @Published var errorMessage: String?
    /// Mirrors AudioRecorder's background health check so the sheet can warn
    /// the user the moment audio stops reaching disk.
    @Published var recordingHealthy = true

    /// Spoken language for transcription, persisted across launches.
    @Published var language: TranscriptionLanguage {
        didSet { TranscriptionLanguage.preferred = language }
    }

    let recorder = AudioRecorder()

    private var timer: Timer?
    private var startDate: Date?
    private var accumulated: TimeInterval = 0
    /// Guards against re-entrant starts. `start()` awaits permission prompts,
    /// so a fast double tap could otherwise launch two sessions and install a
    /// second tap on the same AVAudioEngine input bus — which crashes. Both
    /// flags are only ever read/written on the main actor.
    private var isStarting = false
    private var isRunning = false

    init() {
        self.language = TranscriptionLanguage.preferred
        recorder.$level.assign(to: &$level)
        recorder.$recordingHealthy.assign(to: &$recordingHealthy)
    }

    /// Requests permissions and begins capture. Returns false if denied or if
    /// a session is already starting/running (so rapid taps can't start twice).
    func start() async -> Bool {
        // Set synchronously before the first `await` so a second call dispatched
        // on the main actor sees the in-progress start and bails out.
        guard !isStarting, !isRunning else { return false }
        isStarting = true
        defer { isStarting = false }

        // Pick up the language preference in case it was changed in Settings
        // since this view model was created.
        let preferred = TranscriptionLanguage.preferred
        if preferred != language { language = preferred }
        let micGranted = await requestMic()
        let speechGranted = await SpeechTranscriber.requestAuthorization()
        guard micGranted, speechGranted else {
            permissionDenied = true
            return false
        }
        do {
            try recorder.start()
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
        isRunning = true
        startDate = .now
        startTimer()
        return true
    }

    func pause() {
        guard !isPaused else { return }
        isPaused = true
        recorder.pause()
        accumulated += Date.now.timeIntervalSince(startDate ?? .now)
        timer?.invalidate()
    }

    func resume() {
        guard isPaused else { return }
        do {
            try recorder.resume()
        } catch {
            errorMessage = "Couldn't resume recording: \(error.localizedDescription)"
            return
        }
        isPaused = false
        startDate = .now
        startTimer()
    }

    /// Stops recording and saves the Note immediately; transcription continues
    /// in the background via TranscriptionWorker so navigation is instant and
    /// the work survives this sheet being dismissed.
    func stopAndSave(context: ModelContext) -> Note {
        timer?.invalidate()
        let duration = Int(elapsed.rounded())
        let url = recorder.stop()

        let note = Note(
            durationSeconds: duration,
            audioFileName: url?.lastPathComponent,
            transcript: "",
            status: url == nil ? .transcriptionFailed : .transcribing,
            languageRaw: language.rawValue
        )
        context.insert(note)
        do {
            try context.save()
        } catch {
            errorMessage = "Couldn't save the note: \(error.localizedDescription)"
        }
        if let url {
            TranscriptionWorker.shared.transcribe(
                note: note, fileURL: url, locale: language.locale, context: context
            )
        }
        reset()
        return note
    }

    func cancel() {
        timer?.invalidate()
        let url = recorder.stop()
        if let url { try? FileManager.default.removeItem(at: url) }
        reset()
    }

    private func reset() {
        elapsed = 0
        accumulated = 0
        isPaused = false
        level = 0
        startDate = nil
        isRunning = false
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self, let start = self.startDate else { return }
                self.elapsed = self.accumulated + Date.now.timeIntervalSince(start)
            }
        }
    }

    private func requestMic() async -> Bool {
        await withCheckedContinuation { cont in
            AVAudioApplication.requestRecordPermission { granted in
                cont.resume(returning: granted)
            }
        }
    }
}
