import Foundation

/// Cleans raw local-model output for display.
///
/// Some models (harmony / channel style) emit their reasoning before the
/// answer, e.g. `<|channel|>thought ... <|channel|>final ...`. We drop the
/// reasoning segments and strip the control tokens, keeping only the
/// user-facing content. It runs incrementally, so when applied to a growing
/// stream it naturally hides the "thinking" until the final answer begins.
enum LLMOutput {
    /// Bracketed control tokens like `<|channel|>`, `<|channel>`, `<channel|>`, `<|message|>`.
    private static let markerPattern =
        #"<\|?(?:channel|message|start|end|return|constrain|assistant|system|user|final|analysis|thought|commentary)\|?>"#

    /// Compiled once — `sanitize` is called repeatedly while streaming.
    private static let markerRegex = try? NSRegularExpression(pattern: markerPattern, options: [.caseInsensitive])

    private static let reasoningNames = ["thought", "analysis", "commentary"]

    static func sanitize(_ raw: String) -> String {
        let sentinel = "\u{0001}"
        guard let regex = markerRegex else {
            return raw.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let ns = raw as NSString
        let replaced = regex.stringByReplacingMatches(
            in: raw,
            range: NSRange(location: 0, length: ns.length),
            withTemplate: sentinel
        )
        // No control tokens → plain output, nothing to strip.
        guard replaced.contains(sentinel) else {
            return raw.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        var kept: [String] = []
        var prevWasReasoningName = false
        for segment in replaced.components(separatedBy: sentinel) {
            let lower = segment.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if lower.isEmpty { continue }

            // Content that follows a bare reasoning channel name (e.g. "analysis<|message|>…").
            if prevWasReasoningName {
                prevWasReasoningName = false
                continue
            }
            // Segment opening a reasoning channel ("thought…", "analysis", "commentary").
            if let name = reasoningNames.first(where: { lower.hasPrefix($0) }) {
                prevWasReasoningName = (lower == name) // name-only → reasoning is in the next segment
                continue
            }
            // Keep user-facing content, dropping any leading channel label.
            let cleaned = segment.replacingOccurrences(
                of: #"^\s*(?:final|message|assistant|channel)\b[:\-]?\s*"#,
                with: "",
                options: [.regularExpression, .caseInsensitive]
            ).trimmingCharacters(in: .whitespacesAndNewlines)
            if !cleaned.isEmpty { kept.append(cleaned) }
        }
        return kept.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
