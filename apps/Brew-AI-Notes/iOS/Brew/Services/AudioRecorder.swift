import AVFoundation
import Foundation
import OSLog

/// Captures microphone audio with AVAudioEngine: writes a recording file to
/// Documents, publishes a normalized input level for the meter, and monitors
/// in the background that audio is actually reaching disk.
@MainActor
final class AudioRecorder: ObservableObject {
    @Published var level: Float = 0          // 0...1 smoothed RMS
    @Published var isRunning = false
    /// False when buffers stop reaching the file (write errors, or the file
    /// stops growing while recording) so the UI can warn before data is lost.
    @Published var recordingHealthy = true

    private let engine = AVAudioEngine()
    private var file: AVAudioFile?
    private(set) var fileURL: URL?
    private var watchdog: Timer?
    private var lastFileSize: UInt64 = 0
    private var consecutiveWriteFailures = 0
    private let log = Logger(subsystem: "com.brew.app", category: "recording")

    func start() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default, options: [.duckOthers, .defaultToSpeaker])
        try session.setActive(true, options: .notifyOthersOnDeactivation)

        let input = engine.inputNode
        let format = input.outputFormat(forBus: 0)

        let url = Self.makeFileURL()
        let outFile = try AVAudioFile(forWriting: url, settings: format.settings)
        self.file = outFile
        self.fileURL = url
        recordingHealthy = true
        consecutiveWriteFailures = 0
        lastFileSize = 0

        input.installTap(onBus: 0, bufferSize: 4096, format: format) { [weak self] buffer, _ in
            guard let self else { return }
            var writeError: Error?
            do {
                try outFile.write(from: buffer)
            } catch {
                writeError = error
            }
            let rms = Self.rms(buffer)
            Task { @MainActor in
                self.updateLevel(rms)
                self.recordWriteResult(error: writeError)
            }
        }

        engine.prepare()
        try engine.start()
        isRunning = true
        startWatchdog()
    }

    func pause() {
        engine.pause()
        isRunning = false
    }

    func resume() throws {
        try engine.start()
        isRunning = true
    }

    /// Stops capture and returns the recorded file URL.
    func stop() -> URL? {
        watchdog?.invalidate()
        watchdog = nil
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        file = nil
        isRunning = false
        level = 0
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        return fileURL
    }

    // MARK: - Health monitoring

    private func recordWriteResult(error: Error?) {
        if let error {
            consecutiveWriteFailures += 1
            log.error("Audio buffer write failed (\(self.consecutiveWriteFailures)): \(error.localizedDescription, privacy: .public)")
            if consecutiveWriteFailures >= 5 {
                recordingHealthy = false
            }
        } else {
            consecutiveWriteFailures = 0
        }
    }

    /// Every 5 seconds while recording, verify the file on disk is growing.
    /// Catches failures the write call can't see (disk full, file handle
    /// invalidated, engine silently stalled).
    private func startWatchdog() {
        watchdog?.invalidate()
        watchdog = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.checkFileGrowth() }
        }
    }

    private func checkFileGrowth() {
        guard isRunning, let path = fileURL?.path else { return }
        let attrs = try? FileManager.default.attributesOfItem(atPath: path)
        let size = (attrs?[.size] as? UInt64) ?? 0
        if size > lastFileSize {
            lastFileSize = size
            // Growth resumed — clear a transient warning.
            if recordingHealthy == false && consecutiveWriteFailures == 0 {
                recordingHealthy = true
            }
        } else {
            log.error("Recording file is not growing (size: \(self.lastFileSize)) — flagging unhealthy")
            recordingHealthy = false
        }
    }

    // MARK: - Helpers

    private func updateLevel(_ rms: Float) {
        // Map RMS to a lively 0...1 meter with smoothing.
        let normalized = min(1, max(0, (rms * 20)))
        level = level * 0.6 + normalized * 0.4
    }

    private static func rms(_ buffer: AVAudioPCMBuffer) -> Float {
        guard let channel = buffer.floatChannelData?[0] else { return 0 }
        let count = Int(buffer.frameLength)
        guard count > 0 else { return 0 }
        var sum: Float = 0
        for i in 0..<count { sum += channel[i] * channel[i] }
        return (sum / Float(count)).squareRoot()
    }

    private static func makeFileURL() -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("rec-\(UUID().uuidString).caf")
    }
}
