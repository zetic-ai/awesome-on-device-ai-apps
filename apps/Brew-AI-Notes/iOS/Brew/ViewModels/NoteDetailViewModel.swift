import Foundation
import SwiftData

/// Generates the AI note (enhance) and title for a note, streaming the note
/// content as it arrives so the user sees progress.
@MainActor
final class NoteDetailViewModel: ObservableObject {
    @Published var isGenerating = false
    @Published var streamingText = ""
    @Published var errorMessage: String?

    private let llm = LLMService.shared

    /// Produces the enhanced markdown note and a title, persisting both.
    func generate(for note: Note, context: ModelContext) async {
        guard !isGenerating else { return }
        isGenerating = true
        streamingText = ""
        errorMessage = nil
        note.status = .enhancing

        await llm.ensureLoaded()
        if let loadError = llm.loadError {
            errorMessage = loadError
            note.status = .transcribed
            isGenerating = false
            return
        }

        do {
            // Enhance: stream so the UI fills in live.
            let enhancePrompt = Prompts.enhance(
                transcript: note.transcript,
                title: note.title,
                date: note.createdAt
            )
            // The note targets ~300 words; cap decode to bound worst-case
            // generation while leaving headroom above the target length.
            let clean = try await llm.generateSanitized(prompt: enhancePrompt, maxTokens: 512) { partial in
                streamingText = partial
            }
            streamingText = clean
            note.enhancedNote = clean

            // Derive the title from the note's first heading — no second model
            // pass, which keeps note generation fast.
            let title = deriveTitle(from: clean)
            if !title.isEmpty { note.title = title }

            note.status = .enhanced
            try? context.save()
        } catch {
            errorMessage = error.localizedDescription
            note.status = .transcribed
        }
        isGenerating = false
    }

    /// First markdown heading, else the first meaningful line, as the title.
    private func deriveTitle(from note: String) -> String {
        let lines = note.components(separatedBy: .newlines)
        if let heading = lines.first(where: { $0.trimmingCharacters(in: .whitespaces).hasPrefix("# ") }) {
            return String(heading.trimmingCharacters(in: .whitespaces).dropFirst(2)).trimmingCharacters(in: .whitespaces)
        }
        let strip = CharacterSet(charactersIn: "#*-• ").union(.whitespaces)
        if let line = lines.first(where: { !$0.trimmingCharacters(in: strip).isEmpty }) {
            return String(line.trimmingCharacters(in: strip).prefix(60))
        }
        return ""
    }
}
