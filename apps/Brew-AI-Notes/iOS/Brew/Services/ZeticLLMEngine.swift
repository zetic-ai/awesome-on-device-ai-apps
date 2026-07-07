#if !targetEnvironment(simulator)
import Foundation
import OSLog
import ZeticMLange

/// Real on-device engine backed by ZeticMLange. Compiled only for physical
/// devices — the ZeticMLange xcframework ships no simulator slice.
final class ZeticLLMEngine: LLMEngine {
    private var model: ZeticMLangeLLMModel?
    private let personalKey: String
    private let modelName: String
    private let log = Logger(subsystem: "com.brew.app", category: "llm")

    init(personalKey: String, modelName: String) {
        self.personalKey = personalKey
        self.modelName = modelName
    }

    func load(onProgress: @escaping (Double) -> Void) throws {
        guard !personalKey.isEmpty else { throw LLMError.missingKey }
        model = try ZeticMLangeLLMModel(
            personalKey: personalKey,
            name: modelName,
            version: 1,
            modelMode: LLMModelMode.RUN_SPEED,
            // nCtx 4096 doubles the default context window so trimmed prompts
            // plus chat history fit without KV-cache thrashing.
            initOption: LLMInitOption(kvCacheCleanupPolicy: .CLEAN_UP_ON_FULL, nCtx: 4096),
            onDownload: { progress in onProgress(Double(progress)) }
        )
    }

    func startGeneration(prompt: String) throws -> Int {
        guard let model else { throw LLMError.notReady }
        let result = try model.run(prompt)
        log.info("Generation started with \(result.promptTokens) prompt tokens")
        return result.promptTokens
    }

    func nextToken() -> (token: String, isFinished: Bool) {
        guard let model else { return ("", true) }
        let result = model.waitForNextToken()
        return (result.token, result.isFinished)
    }

    func stopGeneration() {
        do {
            try model?.cleanUp()
        } catch {
            log.error("stopGeneration cleanUp failed: \(error.localizedDescription, privacy: .public)")
        }
    }
}
#endif
