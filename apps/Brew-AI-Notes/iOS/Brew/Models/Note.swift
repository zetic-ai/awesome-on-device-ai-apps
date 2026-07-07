import Foundation
import SwiftData

/// Lifecycle of a note's AI processing.
enum NoteStatus: String, Codable {
    case recording              // capture in progress (rarely persisted)
    case transcribing           // audio saved, transcription running in background
    case transcriptionFailed    // transcription errored; audio retained for retry
    case transcribed            // raw transcript saved, AI note not yet generated
    case enhancing      // enhance/title generation underway
    case enhanced       // AI note + title ready
}

@Model
final class Note {
    @Attribute(.unique) var id: UUID
    var title: String
    var createdAt: Date
    var durationSeconds: Int
    var audioFileName: String?
    var transcript: String
    var enhancedNote: String?
    var statusRaw: String
    /// Why the last transcription attempt failed — persisted so the detail
    /// screen can explain the failure even after a relaunch.
    var transcriptionErrorMessage: String?
    /// Locale identifier the recording was made with, so retries transcribe
    /// in the right language even if the global preference changed since.
    var languageRaw: String?

    @Relationship(deleteRule: .cascade, inverse: \ChatMessage.note)
    var messages: [ChatMessage]

    init(
        id: UUID = UUID(),
        title: String = "",
        createdAt: Date = .now,
        durationSeconds: Int = 0,
        audioFileName: String? = nil,
        transcript: String = "",
        enhancedNote: String? = nil,
        status: NoteStatus = .transcribed,
        transcriptionErrorMessage: String? = nil,
        languageRaw: String? = nil
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.durationSeconds = durationSeconds
        self.audioFileName = audioFileName
        self.transcript = transcript
        self.enhancedNote = enhancedNote
        self.statusRaw = status.rawValue
        self.transcriptionErrorMessage = transcriptionErrorMessage
        self.languageRaw = languageRaw
        self.messages = []
    }

    var status: NoteStatus {
        get { NoteStatus(rawValue: statusRaw) ?? .transcribed }
        set { statusRaw = newValue.rawValue }
    }

    /// Title shown in lists — falls back to a draft label before AI naming.
    var displayTitle: String {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "New note" : trimmed
    }
}
