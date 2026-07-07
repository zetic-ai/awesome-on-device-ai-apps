import SwiftUI
import SwiftData

/// Conversational chat grounded in a single note's transcript + summary.
struct ChatView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var note: Note

    @StateObject private var vm = ChatViewModel()
    @State private var input = ""

    private var sortedMessages: [ChatMessage] {
        note.messages.sorted { $0.createdAt < $1.createdAt }
    }

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
            .navigationTitle("Chat with note")
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
                    if sortedMessages.isEmpty && !vm.isResponding {
                        Text("Ask anything about this meeting — decisions, action items, who said what.")
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.inkSecondary)
                            .padding(.top, 24)
                    }
                    ForEach(sortedMessages) { msg in
                        bubble(role: msg.role, text: msg.content)
                            .id(msg.id)
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
            .onChange(of: note.messages.count) { _, _ in
                if let last = sortedMessages.last {
                    withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
        }
    }

    private func bubble(role: ChatRole, text: String) -> some View {
        HStack {
            if role == .user { Spacer(minLength: 40) }
            Group {
                if role == .assistant {
                    MarkdownView(markdown: text)
                } else {
                    Text(text).font(.system(size: 16))
                }
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
            TextField("Ask about this note…", text: $input, axis: .vertical)
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
        Task { await vm.send(text, note: note, context: context) }
    }
}
