import SwiftUI
import SwiftData
import UIKit

/// A note's detail: serif title, date pill, segmented Note / Transcript, and a
/// floating "Chat with note" pill. Generates the AI note on first open.
struct NoteDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var note: Note

    @StateObject private var vm = NoteDetailViewModel()
    @ObservedObject private var llm = LLMService.shared
    @State private var tab: Tab = .note
    @State private var showChat = false
    @State private var shareItems: [Any]?
    @State private var showCopied = false

    enum Tab: String, CaseIterable { case note = "Note", transcript = "Transcript" }

    var body: some View {
        ZStack(alignment: .bottom) {
            Theme.canvas.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    titleBlock
                    picker
                    // Until a transcript exists, both tabs show the same
                    // pipeline state, so gate once above the tab switch.
                    if note.status == .transcribing {
                        transcribingStatus
                    } else if note.status == .transcriptionFailed {
                        transcriptionFailedView
                    } else {
                        body(for: tab)
                    }
                    Color.clear.frame(height: 100)
                }
                .padding(.horizontal, 22)
                .padding(.top, 8)
            }

            chatPill
        }
        .navigationBarBackButtonHidden(true)
        .toolbar { toolbarContent }
        .toolbarBackground(Theme.canvas, for: .navigationBar)
        .sheet(isPresented: $showChat) {
            ChatView(note: note)
        }
        .sheet(isPresented: Binding(get: { shareItems != nil }, set: { if !$0 { shareItems = nil } })) {
            if let items = shareItems {
                ShareSheet(items: items)
                    .presentationDetents([.medium, .large])
            }
        }
        .overlay(alignment: .top) {
            if showCopied {
                Text("Copied to clipboard")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16).padding(.vertical, 10)
                    .background(Theme.accent, in: Capsule())
                    .padding(.top, 8)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .task {
            if note.enhancedNote == nil && note.status == .transcribed && !note.transcript.isEmpty {
                await vm.generate(for: note, context: context)
            }
        }
        .onChange(of: note.statusRaw) { _, newValue in
            // Background transcription finished while this screen is open —
            // continue straight into AI note generation.
            if newValue == NoteStatus.transcribed.rawValue,
               note.enhancedNote == nil, !note.transcript.isEmpty {
                Task { await vm.generate(for: note, context: context) }
            }
        }
    }

    // MARK: - Pieces

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(note.displayTitle)
                .font(Theme.serif(31, weight: .regular))
                .foregroundStyle(Theme.ink)

            HStack(spacing: 8) {
                Image(systemName: "calendar")
                Text(note.createdAt.formatted(date: .abbreviated, time: .shortened))
            }
            .font(.system(size: 15))
            .foregroundStyle(Theme.inkSecondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Theme.cardElevated)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Theme.card))
        }
    }

    private var picker: some View {
        Picker("View", selection: $tab) {
            ForEach(Tab.allCases, id: \.self) { Text($0.rawValue).tag($0) }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    private func body(for tab: Tab) -> some View {
        switch tab {
        case .note:
            if vm.isGenerating {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        ProgressView().controlSize(.small)
                        switch llm.phase {
                        case .downloading(let p):
                            Text("Downloading AI model… \(Int(p * 100))%")
                                .foregroundStyle(Theme.inkSecondary)
                        case .idle, .preparing:
                            Text("Preparing AI…").foregroundStyle(Theme.inkSecondary)
                        case .ready, .failed:
                            Text("Generating note…").foregroundStyle(Theme.inkSecondary)
                        }
                    }
                    if !vm.streamingText.isEmpty {
                        MarkdownView(markdown: vm.streamingText)
                    }
                }
            } else if let error = vm.errorMessage {
                generationError(error)
            } else if let enhanced = note.enhancedNote, !enhanced.isEmpty {
                MarkdownView(markdown: enhanced)
            } else {
                emptyNotePrompt
            }
        case .transcript:
            if note.transcript.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("No speech was detected in this recording.")
                        .font(.system(size: 17))
                        .foregroundStyle(Theme.inkTertiary)
                    if note.audioFileName != nil {
                        retryTranscriptionButton
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text(note.transcript)
                    .font(.system(size: 17))
                    .foregroundStyle(Theme.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var transcribingStatus: some View {
        HStack(spacing: 8) {
            ProgressView().controlSize(.small)
            Text("Transcribing recording…").foregroundStyle(Theme.inkSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var transcriptionFailedView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Transcription failed.")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Theme.ink)
            if let reason = note.transcriptionErrorMessage {
                Text(reason).font(.system(size: 14)).foregroundStyle(Theme.inkSecondary)
            }
            Text("Your recording is saved, so nothing is lost.")
                .font(.system(size: 14))
                .foregroundStyle(Theme.inkSecondary)
            if note.audioFileName != nil {
                retryTranscriptionButton
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var retryTranscriptionButton: some View {
        Button("Retry transcription") {
            TranscriptionWorker.shared.retry(note: note, context: context)
        }
        .buttonStyle(.bordered)
        .tint(Theme.accent)
    }

    private var emptyNotePrompt: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("No AI note yet.")
                .foregroundStyle(Theme.inkSecondary)
            Button("Generate note") {
                Task { await vm.generate(for: note, context: context) }
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.accent)
        }
    }

    private func generationError(_ message: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Couldn't generate the note.")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Theme.ink)
            Text(message).font(.system(size: 14)).foregroundStyle(Theme.inkSecondary)
            Button("Try again") {
                Task { await vm.generate(for: note, context: context) }
            }
            .buttonStyle(.bordered)
            .tint(Theme.accent)
        }
    }

    private var chatPill: some View {
        Button { showChat = true } label: {
            Label("Chat with note", systemImage: "bubble.left.fill")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 16)
                .background(Theme.accent)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.18), radius: 12, y: 4)
        }
        .buttonStyle(.plain)
        .padding(.bottom, 10)
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Theme.ink)
                    .frame(width: 40, height: 40)
                    .background(Theme.card)
                    .clipShape(Circle())
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Section("Share as") {
                    ForEach(ExportFormat.allCases) { format in
                        Button {
                            if let url = NoteExporter.export(note, as: format) {
                                shareItems = [url]
                            }
                        } label: {
                            Label(format.rawValue, systemImage: format.icon)
                        }
                    }
                }
                Button {
                    UIPasteboard.general.string = NoteExporter.copyText(for: note)
                    withAnimation { showCopied = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { showCopied = false }
                    }
                } label: {
                    Label("Copy text", systemImage: "doc.on.doc")
                }
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .foregroundStyle(Theme.ink)
                    .frame(width: 40, height: 40)
                    .background(Theme.card)
                    .clipShape(Circle())
            }
        }
    }

}
