import SwiftUI

/// Unobtrusive inline status for the on-device model: a small capsule with
/// download progress while the model prepares, a tap-to-retry state on
/// failure, and nothing at all once the model is ready. Never blocks the UI.
struct ModelStatusChip: View {
    @ObservedObject private var llm = LLMService.shared

    var body: some View {
        switch llm.phase {
        case .downloading(let progress):
            statusCapsule {
                ProgressView(value: progress)
                    .progressViewStyle(.circular)
                    .controlSize(.mini)
                    .tint(Theme.iconTileInk)
                Text("Downloading AI · \(Int(progress * 100))%")
                    .font(.system(size: 13, weight: .medium).monospacedDigit())
                    .foregroundStyle(Theme.inkSecondary)
            }
        case .idle, .preparing:
            // Initialization has no progress signal — show an indeterminate
            // spinner rather than a frozen percentage.
            statusCapsule {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.mini)
                    .tint(Theme.iconTileInk)
                Text("Preparing AI…")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Theme.inkSecondary)
            }
        case .failed:
            Button {
                Task { await LLMService.shared.ensureLoaded() }
            } label: {
                statusCapsule {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 12, weight: .semibold))
                    Text("AI unavailable — tap to retry")
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundStyle(.orange)
            }
            .buttonStyle(.plain)
        case .ready:
            EmptyView()
        }
    }

    private func statusCapsule<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        HStack(spacing: 8) {
            content()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(Theme.cardElevated)
        .clipShape(Capsule())
    }
}
