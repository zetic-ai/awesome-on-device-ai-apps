import SwiftUI
import SwiftData

/// Settings sheet opened from the profile button: transcription language,
/// on-device AI status, local storage usage, and app version. Brew is fully
/// local — there is no account, so this is the "profile".
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var notes: [Note]
    @ObservedObject private var llm = LLMService.shared

    @AppStorage("transcriptionLanguage") private var languageRaw = TranscriptionLanguage.english.rawValue
    @State private var audioBytes: Int64 = 0

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.canvas.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        section("Transcription") { languageRow }
                        section("On-device AI") { modelRow }
                        section("Storage") { storageRow }
                        section("About") { aboutRow }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.tint(Theme.ink)
                }
            }
        }
        .onAppear(perform: computeAudioSize)
    }

    // MARK: - Rows

    private var languageRow: some View {
        HStack {
            Label("Spoken language", systemImage: "globe")
                .font(.system(size: 16))
                .foregroundStyle(Theme.ink)
            Spacer()
            Picker("Spoken language", selection: $languageRaw) {
                ForEach(TranscriptionLanguage.allCases) { lang in
                    Text(lang.displayName).tag(lang.rawValue)
                }
            }
            .tint(Theme.inkSecondary)
        }
    }

    @ViewBuilder
    private var modelRow: some View {
        HStack(spacing: 10) {
            if let progress = llm.downloadProgress {
                ProgressView(value: progress)
                    .progressViewStyle(.circular)
                    .controlSize(.small)
                    .tint(Theme.iconTileInk)
                Text("Downloading model… \(Int(progress * 100))%")
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.inkSecondary)
            } else if llm.isModelReady {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Theme.iconTileInk)
                Text("Ready — runs privately on this device")
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.ink)
            } else if let error = llm.loadError {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Unavailable", systemImage: "exclamationmark.triangle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.orange)
                    Text(error)
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.inkSecondary)
                    Button("Retry download") {
                        Task { await LLMService.shared.ensureLoaded() }
                    }
                    .buttonStyle(.bordered)
                    .tint(Theme.accent)
                }
            } else {
                Image(systemName: "sparkles")
                    .foregroundStyle(Theme.iconTileInk)
                Text("Preparing…")
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.inkSecondary)
            }
            Spacer(minLength: 0)
        }
    }

    private var storageRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Notes", systemImage: "doc.text")
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.ink)
                Spacer()
                Text("\(notes.count)")
                    .font(.system(size: 16).monospacedDigit())
                    .foregroundStyle(Theme.inkSecondary)
            }
            HStack {
                Label("Recordings", systemImage: "waveform")
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.ink)
                Spacer()
                Text(ByteCountFormatter.string(fromByteCount: audioBytes, countStyle: .file))
                    .font(.system(size: 16).monospacedDigit())
                    .foregroundStyle(Theme.inkSecondary)
            }
        }
    }

    private var aboutRow: some View {
        HStack {
            Label("Version", systemImage: "info.circle")
                .font(.system(size: 16))
                .foregroundStyle(Theme.ink)
            Spacer()
            Text(appVersion)
                .font(.system(size: 16))
                .foregroundStyle(Theme.inkSecondary)
        }
    }

    // MARK: - Helpers

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Theme.inkSecondary)
                .textCase(.uppercase)
            content()
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.cardElevated)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    private var appVersion: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        return build.map { "\(version) (\($0))" } ?? version
    }

    private func computeAudioSize() {
        let files = (try? FileManager.default.contentsOfDirectory(
            at: TranscriptionWorker.documentsURL, includingPropertiesForKeys: [.fileSizeKey]
        )) ?? []
        audioBytes = files
            .filter { $0.lastPathComponent.hasPrefix("rec-") }
            .compactMap { try? $0.resourceValues(forKeys: [.fileSizeKey]).fileSize }
            .reduce(Int64(0)) { $0 + Int64($1) }
    }
}
