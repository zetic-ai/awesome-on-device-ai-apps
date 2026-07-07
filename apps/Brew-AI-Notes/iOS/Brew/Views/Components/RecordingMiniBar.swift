import SwiftUI

/// Animated level bars shown while recording (the green tick marks).
struct LevelBars: View {
    var level: Float
    var color: Color = Theme.recording
    private let count = 5

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<count, id: \.self) { i in
                Capsule()
                    .fill(color)
                    .frame(width: 3, height: barHeight(i))
                    .opacity(isActive(i) ? 1 : 0.25)
            }
        }
        .animation(.easeOut(duration: 0.15), value: level)
    }

    private func barHeight(_ i: Int) -> CGFloat {
        let base: CGFloat = 6
        let span: CGFloat = 14
        let phase = CGFloat((i % 3) + 1) / 3
        return base + span * CGFloat(level) * phase
    }

    private func isActive(_ i: Int) -> Bool {
        Float(i) / Float(count) <= level + 0.05
    }
}

/// Compact bar pinned to the bottom of the notes list while a recording is in
/// progress (matches "New note · 00:08" in the reference).
struct RecordingMiniBar: View {
    let title: String
    let elapsed: TimeInterval
    let level: Float
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                Text("·")
                    .foregroundStyle(.white.opacity(0.6))
                Text(timeString(elapsed))
                    .font(.system(size: 16, weight: .semibold).monospacedDigit())
                    .foregroundStyle(Theme.recording)
                LevelBars(level: level)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(Theme.accent)
        }
        .buttonStyle(.plain)
    }
}

func timeString(_ t: TimeInterval) -> String {
    let total = Int(t)
    return String(format: "%02d:%02d", total / 60, total % 60)
}
