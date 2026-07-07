import Foundation

/// Placeholder engine used in the iOS Simulator, where the device-only
/// ZeticMLange framework can't run. It streams canned text so the full UI —
/// recording, transcript, note layout, chat — is exercisable without a device.
final class StubLLMEngine: LLMEngine {
    private var pending: [String] = []
    private var index = 0

    func load(onProgress: @escaping (Double) -> Void) throws {
        // Simulate a quick "download" so the progress UI is visible once.
        for step in stride(from: 0.0, through: 1.0, by: 0.25) {
            onProgress(step)
            Thread.sleep(forTimeInterval: 0.08)
        }
    }

    func startGeneration(prompt: String) throws -> Int {
        let demo = """
        # Simulator preview

        - The on-device AI model runs only on a physical iPhone.
        - This placeholder text lets you exercise the interface in the Simulator.
        - Build to a connected device to generate real notes and chat replies.
        """
        // Tokenize into word-ish chunks so streaming looks natural.
        pending = demo.split(separator: " ", omittingEmptySubsequences: false).map { $0 + " " }
        index = 0
        return prompt.count / 4
    }

    func nextToken() -> (token: String, isFinished: Bool) {
        guard index < pending.count else { return ("", true) }
        let token = pending[index]
        index += 1
        Thread.sleep(forTimeInterval: 0.02)
        return (token, false)
    }

    func stopGeneration() {
        pending = []
        index = 0
    }
}
