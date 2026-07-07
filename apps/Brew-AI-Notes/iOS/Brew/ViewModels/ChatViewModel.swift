import Foundation
import SwiftData

/// Per-note chat. Persists messages on the note and streams the assistant
/// reply token-by-token.
@MainActor
final class ChatViewModel: ObservableObject {
    @Published var streamingReply = ""
    @Published var isResponding = false
    @Published var errorMessage: String?

    private let llm = LLMService.shared

    func send(_ text: String, note: Note, context: ModelContext) async {
        let question = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty, !isResponding else { return }

        let userMessage = ChatMessage(role: .user, content: question, note: note)
        context.insert(userMessage)
        do {
            try context.save()
        } catch {
            errorMessage = "Couldn't save your message: \(error.localizedDescription)"
            return
        }

        isResponding = true
        streamingReply = ""
        errorMessage = nil

        await llm.ensureLoaded()
        if let loadError = llm.loadError {
            errorMessage = loadError
            isResponding = false
            return
        }

        let history = note.messages
            .sorted { $0.createdAt < $1.createdAt }
            .filter { $0.id != userMessage.id }
            .map { (role: $0.role, content: $0.content) }

        let prompt = Prompts.chatPrompt(
            system: Prompts.chatSystem(),
            context: Prompts.noteContext(
                title: note.title,
                date: note.createdAt,
                enhancedNote: note.enhancedNote,
                transcript: note.transcript
            ),
            history: history,
            question: question
        )

        do {
            // Chat answers are a few sentences; cap decode to bound worst-case
            // runaway generation (the dominant tail-latency source here).
            let reply = try await llm.generateSanitized(prompt: prompt, maxTokens: 320) { partial in
                streamingReply = partial
            }
            let assistant = ChatMessage(role: .assistant, content: reply, note: note)
            context.insert(assistant)
            do {
                try context.save()
            } catch {
                errorMessage = "Couldn't save the reply: \(error.localizedDescription)"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        streamingReply = ""
        isResponding = false
    }
}
