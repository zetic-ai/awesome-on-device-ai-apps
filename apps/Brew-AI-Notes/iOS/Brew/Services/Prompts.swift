import Foundation

/// Builds the prompts handed to the local LLM. The structure and wording are
/// adapted from the reference app's Jinja templates (enhance / title / chat),
/// trimmed to Brew's feature set (no participants, folders, or templates).
enum Prompts {
    // MARK: - Context budgets
    //
    // Keeping prompts small is the main latency lever: llama.cpp prefill cost
    // is linear in prompt tokens and the whole prompt is re-processed on every
    // turn (no session reuse in the SDK). Budgets are in characters, sized
    // conservatively (~3 chars/token) against the 4096-token context window.

    private static let enhancedNoteBudget = 3_000
    private static let transcriptBudget = 6_000
    private static let transcriptOnlyBudget = 8_000
    private static let enhanceTranscriptBudget = 9_000
    private static let historyTurns = 2
    private static let historyTurnBudget = 400

    /// Trims overlong text by keeping the head (agenda, context) and the tail
    /// (decisions, action items) — the middle is the least information-dense.
    static func truncateMiddle(_ text: String, maxChars: Int) -> String {
        guard text.count > maxChars else { return text }
        let headCount = maxChars * 6 / 10
        let tailCount = maxChars - headCount
        return "\(text.prefix(headCount))\n…[middle of transcript trimmed]…\n\(text.suffix(tailCount))"
    }

    private static func trimmedHistory(
        _ history: [(role: ChatRole, content: String)], turns: Int
    ) -> [(role: ChatRole, content: String)] {
        history.suffix(turns).map { ($0.role, String($0.content.prefix(historyTurnBudget))) }
    }

    private static var todayString: String {
        let f = DateFormatter()
        f.dateStyle = .full
        return f.string(from: .now)
    }

    private static func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: date)
    }

    // MARK: - Enhance (transcript -> structured markdown note)

    static func enhance(transcript: String, title: String, date: Date) -> String {
        let system = """
        Turn the meeting transcript into clean, concise notes in English.
        Use Markdown: a few short `#` headings, each with 2-4 bullets.
        Capture key topics, decisions, and action items — brief, no filler, under ~300 words.
        Output only the notes: no preamble, reasoning, or commentary.
        """

        let trimmed = truncateMiddle(transcript, maxChars: enhanceTranscriptBudget)
        let user = """
        Transcript:
        \(trimmed.isEmpty ? "(no speech was transcribed)" : trimmed)
        """

        return compose(system: system, user: user)
    }

    // MARK: - Title (note -> single concise line)

    static func title(forNote note: String) -> String {
        let system = """
        # General Instructions

        Current date: \(todayString)

        You are a professional assistant that generates a perfect title for a meeting note.

        # Format Requirements

        - Always write the title in English, even if the note is in another language.
        - Only output the title as plaintext, nothing else. No characters like *"'([{}]):.
        - Never ask questions or request more information.
        - If the note is empty or has no meaningful content, output exactly: <EMPTY>
        """

        let user = """
        <note>
        \(note)
        </note>

        Now, give me a SUPER CONCISE title for the above note. Only about the topic of the meeting.
        """

        return compose(system: system, user: user)
    }

    // MARK: - Chat (single note)

    static func chatSystem() -> String {
        """
        You are Brew AI, a meeting assistant. Today is \(todayString).
        Answer in English, in a few direct sentences — no preamble, no reasoning.
        Use only the provided transcript and summary; never invent details that are not present.
        """
    }

    static func noteContext(title: String, date: Date, enhancedNote: String?, transcript: String) -> String {
        var block = "<context>\n"
        block += "Title: \(title.isEmpty ? "Untitled" : title)\n"
        block += "Date: \(dateString(date))\n"
        // The enhanced note is the densest representation of the meeting, so it
        // gets priority; the transcript gets a bigger share only when there is
        // no summary to lean on.
        let hasSummary: Bool
        if let enhanced = enhancedNote, !enhanced.isEmpty {
            block += "Meeting Summary:\n\(String(enhanced.prefix(enhancedNoteBudget)))\n"
            hasSummary = true
        } else {
            hasSummary = false
        }
        let budget = hasSummary ? transcriptBudget : transcriptOnlyBudget
        let trimmed = truncateMiddle(transcript, maxChars: budget)
        block += "Full Transcript:\n\(trimmed.isEmpty ? "(empty)" : trimmed)\n"
        block += "</context>"
        return block
    }

    /// Builds a single flattened prompt for the chat turn: system + context +
    /// prior turns + the new question. The local model takes one string.
    static func chatPrompt(system: String, context: String, history: [(role: ChatRole, content: String)], question: String) -> String {
        var parts = [system, context]
        for turn in trimmedHistory(history, turns: historyTurns) {
            let speaker = turn.role == .user ? "User" : "Assistant"
            parts.append("\(speaker): \(turn.content)")
        }
        parts.append("User: \(question)")
        parts.append("Assistant:")
        return parts.joined(separator: "\n\n")
    }

    // MARK: - Ask anything (across all notes)

    static func askAnythingPrompt(notesContext: String, history: [(role: ChatRole, content: String)], question: String) -> String {
        let system = """
        You are Brew AI, answering across the user's meeting notes. Today is \(todayString).
        Answer in English, in a few direct sentences — no preamble, no reasoning.
        Use only the provided notes; if the answer isn't there, say so. Cite the meeting when relevant.
        """
        var parts = [system, "<notes>\n\(notesContext)\n</notes>"]
        for turn in trimmedHistory(history, turns: historyTurns) {
            let speaker = turn.role == .user ? "User" : "Assistant"
            parts.append("\(speaker): \(turn.content)")
        }
        parts.append("User: \(question)")
        parts.append("Assistant:")
        return parts.joined(separator: "\n\n")
    }

    // MARK: - Helpers

    private static func compose(system: String, user: String) -> String {
        "\(system)\n\n---\n\n\(user)"
    }
}
