import Foundation

/// Backend-agnostic interface for the local language model. The rest of the app
/// depends only on this protocol — never on a concrete SDK — so the real
/// ZeticMLange engine (device only) and a simulator stub are interchangeable.
///
/// Token generation is exposed as synchronous primitives (`startGeneration` +
/// `nextToken`) so the single owner, `LLMService`, can serialize every call on
/// one queue.
protocol LLMEngine: AnyObject {
    /// Downloads/initializes the model. `onProgress` reports 0...1. Throws on failure.
    func load(onProgress: @escaping (Double) -> Void) throws

    /// Begins a generation for `prompt`. Returns the number of prompt tokens
    /// consumed (diagnostic: a value near the context window means trouble).
    /// Must be balanced by draining `nextToken` or calling `stopGeneration`.
    func startGeneration(prompt: String) throws -> Int

    /// Returns the next token. `isFinished == true` means generation is done.
    func nextToken() -> (token: String, isFinished: Bool)

    /// Aborts the current generation so the engine is ready for a new prompt.
    func stopGeneration()
}
