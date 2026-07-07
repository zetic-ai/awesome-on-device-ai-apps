import AVFoundation
import Foundation
import Speech

/// Spoken language used for transcription. The transcript may be in this
/// language; the AI note and chat are always produced in English (see Prompts).
enum TranscriptionLanguage: String, CaseIterable, Identifiable {
    case english = "en-US"
    case korean = "ko-KR"

    /// Single source of truth for the persisted language preference, shared by
    /// the recorder, Settings, and transcription retries.
    static let preferenceKey = "transcriptionLanguage"
    static var preferred: TranscriptionLanguage {
        get {
            UserDefaults.standard.string(forKey: preferenceKey)
                .flatMap(TranscriptionLanguage.init(rawValue:)) ?? .english
        }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: preferenceKey) }
    }

    var id: String { rawValue }
    var locale: Locale { Locale(identifier: rawValue) }
    var displayName: String {
        switch self {
        case .english: return "English"
        case .korean: return "한국어 (Korean)"
        }
    }
}

/// Why a transcription attempt failed. Distinguishes real failures from a
/// recording that simply contained no speech (which is a successful empty
/// transcript, not an error).
enum TranscriptionError: LocalizedError {
    case notAuthorized
    case recognizerUnavailable
    case onDeviceUnavailable
    case audioFileMissing
    case audioFileInvalid(String)
    case timedOut
    case recognitionFailed(Error)

    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "Speech recognition permission is not granted. Enable it in Settings."
        case .recognizerUnavailable:
            return "Speech recognition isn't available for this language right now."
        case .onDeviceUnavailable:
            return "On-device speech recognition isn't available for this language on this device. "
                + "Brew transcribes entirely on-device, so this language can't be transcribed here. "
                + "Try installing the language under Settings › General › Keyboard, or choose another language."
        case .audioFileMissing:
            return "The recording file could not be found."
        case .audioFileInvalid(let reason):
            return "The recording couldn't be read: \(reason)"
        case .timedOut:
            return "Transcription took too long and was stopped."
        case .recognitionFailed(let error):
            return "Transcription failed: \(error.localizedDescription)"
        }
    }
}

/// Transcribes a finished recording from its audio file. The file is split
/// into short chunks because a single SFSpeechURLRecognitionRequest is
/// unreliable beyond about a minute of audio — long meetings would silently
/// truncate or fail. Each chunk is recognized separately (with a timeout and
/// one retry), then the pieces are joined.
enum SpeechTranscriber {
    /// Maximum audio per recognition request. Apple's recognizers degrade or
    /// fail past ~1 minute, so stay safely under it.
    private static let chunkSeconds: Double = 55
    /// Watchdog per chunk so a hung recognizer can't stall the pipeline forever.
    private static let chunkTimeout: Duration = .seconds(90)

    static func requestAuthorization() async -> Bool {
        await withCheckedContinuation { cont in
            SFSpeechRecognizer.requestAuthorization { status in
                cont.resume(returning: status == .authorized)
            }
        }
    }

    /// Transcribes the audio file end-to-end. Returns the full transcript;
    /// an empty string means the audio genuinely contained no recognizable
    /// speech. All failure modes throw a TranscriptionError instead.
    static func transcribe(fileURL: URL, locale: Locale) async throws -> String {
        guard SFSpeechRecognizer.authorizationStatus() == .authorized else {
            throw TranscriptionError.notAuthorized
        }
        guard let recognizer = SFSpeechRecognizer(locale: locale), recognizer.isAvailable else {
            throw TranscriptionError.recognizerUnavailable
        }
        // Brew transcribes fully on-device (see README); never fall back to
        // Apple's server-backed recognition. If the locale has no on-device
        // model installed, fail with a clear, actionable error instead.
        guard recognizer.supportsOnDeviceRecognition else {
            throw TranscriptionError.onDeviceUnavailable
        }
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw TranscriptionError.audioFileMissing
        }

        let audioFile: AVAudioFile
        do {
            audioFile = try AVAudioFile(forReading: fileURL)
        } catch {
            throw TranscriptionError.audioFileInvalid(error.localizedDescription)
        }
        let sampleRate = audioFile.fileFormat.sampleRate
        guard sampleRate > 0, audioFile.length > 0 else {
            throw TranscriptionError.audioFileInvalid("The recording is empty.")
        }
        let duration = Double(audioFile.length) / sampleRate
        guard duration >= 0.5 else {
            throw TranscriptionError.audioFileInvalid("The recording is too short.")
        }

        let chunkURLs = try splitIntoChunks(audioFile)
        defer { chunkURLs.forEach { try? FileManager.default.removeItem(at: $0) } }

        var pieces: [String] = []
        var lastError: Error?
        var failedChunks = 0
        for url in chunkURLs {
            do {
                let text: String
                do {
                    text = try await recognizeChunk(url: url, recognizer: recognizer)
                } catch {
                    // One retry per chunk for transient recognizer failures.
                    text = try await recognizeChunk(url: url, recognizer: recognizer)
                }
                if !text.isEmpty { pieces.append(text) }
            } catch {
                // Best effort: a persistently failing chunk shouldn't throw
                // away every other chunk's text. Mark the gap and move on.
                failedChunks += 1
                lastError = error
                pieces.append("[…part of the recording couldn't be transcribed…]")
            }
        }
        // Only fail the whole job when nothing at all was recognized.
        if failedChunks == chunkURLs.count, let lastError {
            throw lastError
        }
        return pieces.joined(separator: " ")
    }

    // MARK: - Chunking

    /// Copies the recording into ~55s temp files with the same format,
    /// using pure AVAudioFile frame reads (no re-encoding).
    private static func splitIntoChunks(_ audioFile: AVAudioFile) throws -> [URL] {
        let format = audioFile.processingFormat
        let framesPerChunk = AVAudioFrameCount(chunkSeconds * audioFile.fileFormat.sampleRate)
        let tempDir = FileManager.default.temporaryDirectory

        var urls: [URL] = []
        do {
            audioFile.framePosition = 0
            while audioFile.framePosition < audioFile.length {
                let remaining = AVAudioFrameCount(audioFile.length - audioFile.framePosition)
                let count = min(framesPerChunk, remaining)
                guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: count) else {
                    throw TranscriptionError.audioFileInvalid("Couldn't allocate audio buffer.")
                }
                try audioFile.read(into: buffer, frameCount: count)
                guard buffer.frameLength > 0 else { break }

                let url = tempDir.appendingPathComponent("chunk-\(UUID().uuidString).caf")
                let out = try AVAudioFile(forWriting: url, settings: format.settings)
                try out.write(from: buffer)
                urls.append(url)
            }
        } catch let error as TranscriptionError {
            urls.forEach { try? FileManager.default.removeItem(at: $0) }
            throw error
        } catch {
            urls.forEach { try? FileManager.default.removeItem(at: $0) }
            throw TranscriptionError.audioFileInvalid(error.localizedDescription)
        }
        return urls
    }

    // MARK: - Recognition

    /// Recognizes one chunk with a watchdog timeout. Throws on recognizer
    /// errors; returns "" for chunks that contain no speech.
    private static func recognizeChunk(url: URL, recognizer: SFSpeechRecognizer) async throws -> String {
        try await withThrowingTaskGroup(of: String.self) { group in
            group.addTask {
                try await runRecognition(url: url, recognizer: recognizer)
            }
            group.addTask {
                try await Task.sleep(for: chunkTimeout)
                throw TranscriptionError.timedOut
            }
            guard let first = try await group.next() else {
                throw TranscriptionError.timedOut
            }
            group.cancelAll()
            return first
        }
    }

    /// Bridges the recognizer callback to async/await with exactly-once resume
    /// semantics — including on cancellation, so a hung recognizer can't leak
    /// the continuation and deadlock the chunk loop.
    private final class RecognitionBox: @unchecked Sendable {
        private let lock = NSLock()
        private var continuation: CheckedContinuation<String, Error>?
        private var cancelledBeforeStore = false
        var task: SFSpeechRecognitionTask?

        func store(_ cont: CheckedContinuation<String, Error>) {
            lock.lock()
            if cancelledBeforeStore {
                lock.unlock()
                cont.resume(throwing: TranscriptionError.timedOut)
                return
            }
            continuation = cont
            lock.unlock()
        }

        func complete(_ result: Result<String, Error>) {
            lock.lock()
            guard let cont = continuation else { lock.unlock(); return }
            continuation = nil
            lock.unlock()
            cont.resume(with: result)
        }

        func cancel() {
            lock.lock()
            if let cont = continuation {
                continuation = nil
                lock.unlock()
                task?.cancel()
                cont.resume(throwing: TranscriptionError.timedOut)
            } else {
                cancelledBeforeStore = true
                lock.unlock()
                task?.cancel()
            }
        }
    }

    private static func runRecognition(url: URL, recognizer: SFSpeechRecognizer) async throws -> String {
        let request = SFSpeechURLRecognitionRequest(url: url)
        request.shouldReportPartialResults = false
        // Force fully on-device recognition so no audio leaves the device.
        // Locales without an on-device model are rejected up front in
        // `transcribe(fileURL:locale:)`, so this is always supported here.
        request.requiresOnDeviceRecognition = true

        let box = RecognitionBox()
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { (cont: CheckedContinuation<String, Error>) in
                box.store(cont)
                box.task = recognizer.recognitionTask(with: request) { result, error in
                    if let result, result.isFinal {
                        box.complete(.success(result.bestTranscription.formattedString))
                    } else if let error {
                        // "No speech detected" style errors mean an empty chunk,
                        // not a broken pipeline — treat partial text as the answer.
                        if let partial = result?.bestTranscription.formattedString, !partial.isEmpty {
                            box.complete(.success(partial))
                        } else if Self.isNoSpeechError(error) {
                            box.complete(.success(""))
                        } else {
                            box.complete(.failure(TranscriptionError.recognitionFailed(error)))
                        }
                    }
                }
            }
        } onCancel: {
            // The watchdog fired: stop the recognizer and resume the
            // continuation ourselves in case the recognizer never calls back.
            box.cancel()
        }
    }

    /// kAFAssistantErrorDomain 1110 ("No speech detected") and 203 ("Retry")
    /// are how the recognizer reports silent audio — that's a valid empty
    /// transcript, not a failure.
    private static func isNoSpeechError(_ error: Error) -> Bool {
        let ns = error as NSError
        return ns.domain == "kAFAssistantErrorDomain" && (ns.code == 1110 || ns.code == 203)
    }
}
