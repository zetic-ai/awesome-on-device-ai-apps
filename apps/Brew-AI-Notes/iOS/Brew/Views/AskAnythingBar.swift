import SwiftUI

/// Global "Ask anything" chat across every note. Session-only (not persisted).
struct AskAnythingView: View {
    @Environment(\.dismiss) private var dismiss
    let notes: [Note]

    @StateObject private var vm = AskAnythingViewModel()
    @State private var input = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.canvas.ignoresSafeArea()
                VStack(spacing: 0) {
                    messages
                    ModelStatusChip()
                        .padding(.bottom, 4)
                    inputBar
                }
            }
            .navigationTitle("Ask anything")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.tint(Theme.ink)
                }
            }
        }
    }

    private var messages: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 14) {
                    if vm.turns.isEmpty && !vm.isResponding {
                        Text("Ask across all your notes — e.g. \"What did we decide about the US launch?\"")
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.inkSecondary)
                            .padding(.top, 24)
                    }
                    ForEach(vm.turns) { turn in
                        bubble(role: turn.role, text: turn.content).id(turn.id)
                    }
                    if vm.isResponding {
                        Group {
                            if vm.streamingReply.isEmpty {
                                HStack { TypingIndicator(); Spacer(minLength: 40) }
                            } else {
                                bubble(role: .assistant, text: vm.streamingReply)
                            }
                        }
                        .id("streaming")
                    }
                    if let error = vm.errorMessage {
                        Text(error).font(.system(size: 14)).foregroundStyle(.red)
                    }
                }
                .padding(20)
            }
            .onChange(of: vm.streamingReply) { _, _ in
                withAnimation { proxy.scrollTo("streaming", anchor: .bottom) }
            }
            .onChange(of: vm.isResponding) { _, responding in
                if responding { withAnimation { proxy.scrollTo("streaming", anchor: .bottom) } }
            }
        }
    }

    private func bubble(role: ChatRole, text: String) -> some View {
        HStack {
            if role == .user { Spacer(minLength: 40) }
            Group {
                if role == .assistant { MarkdownView(markdown: text) }
                else { Text(text).font(.system(size: 16)) }
            }
            .foregroundStyle(role == .user ? .white : Theme.ink)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(role == .user ? Theme.accent : Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            if role == .assistant { Spacer(minLength: 40) }
        }
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Ask anything…", text: $input, axis: .vertical)
                .font(.system(size: 16))
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(Theme.cardElevated)
                .clipShape(Capsule())
            Button(action: send) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(canSend ? Theme.accent : Theme.inkTertiary)
                    .clipShape(Circle())
            }
            .disabled(!canSend)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Theme.canvas)
    }

    private var canSend: Bool {
        !input.trimmingCharacters(in: .whitespaces).isEmpty && !vm.isResponding
    }

    private func send() {
        let text = input
        input = ""
        Task { await vm.send(text, notes: notes) }
    }
}
