import SwiftUI

/// Three animated dots shown in an assistant bubble while waiting for the model
/// to respond — immediate feedback so the chat never feels frozen.
struct TypingIndicator: View {
    @State private var phase = 0
    private let timer = Timer.publish(every: 0.28, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Theme.inkSecondary)
                    .frame(width: 7, height: 7)
                    .opacity(phase == i ? 1 : 0.3)
                    .scaleEffect(phase == i ? 1 : 0.7)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.25)) { phase = (phase + 1) % 3 }
        }
    }
}
