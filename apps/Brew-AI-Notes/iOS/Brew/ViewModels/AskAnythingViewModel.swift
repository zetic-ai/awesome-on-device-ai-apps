import Foundation

/// Ephemeral global chat that reasons across all notes. Messages live in
/// memory for the session only.
@MainActor
final class AskAnythingViewModel: ObservableObject {
    struct Turn: Identifiable {
        let id = UUID()
        let role: ChatRole
        var content: String
    }

    @Published var turns: [Turn] = []
    @Published var streamingReply = ""
    @Published var isResponding = false
    @Published var errorMessage: String?

    private let llm = LLMService.shared

    func send(_ text: String, notes: [Note]) async {
        let question = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty, !isResponding else { return }

        turns.append(Turn(role: .user, content: question))
        isResponding = true
        streamingReply = ""
        errorMessage = nil

        await llm.ensureLoaded()
        if let loadError = llm.loadError {
            errorMessage = loadError
            isResponding = false
            return
        }

        let history = turns.dropLast().map { (role: $0.role, content: $0.content) }
        let prompt = Prompts.askAnythingPrompt(
            notesContext: notesContext(notes),
            history: Array(history),
            question: question
        )

        do {
            // A few-sentence answer; cap decode to bound worst-case generation.
            let reply = try await llm.generateSanitized(prompt: prompt, maxTokens: 320) { partial in
                streamingReply = partial
            }
            turns.append(Turn(role: .assistant, content: reply))
        } catch {
            errorMessage = error.localizedDescription
        }
        streamingReply = ""
        isResponding = false
    }

    /// Compact context per note. Prefers the enhanced note (already a dense
    /// summary) and keeps the budget small — prompt size is the dominant
    /// latency cost for the on-device model.
    private func notesContext(_ notes: [Note]) -> String {
        notes
            .lazy
            .filter { !($0.enhancedNote ?? $0.transcript).isEmpty }
            .prefix(8)
            .map { note in
                let body = note.enhancedNote ?? note.transcript
                let trimmed = String(body.prefix(500))
                let date = note.createdAt.formatted(date: .abbreviated, time: .shortened)
                return "## \(note.displayTitle) (\(date))\n\(trimmed)"
            }
            .joined(separator: "\n\n")
    }
}
