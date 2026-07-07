import SwiftUI

/// A rounded "pill" container used for header controls and actions.
struct CircleIconButton: View {
    let systemName: String
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Theme.ink)
                .frame(width: 46, height: 46)
                .background(Theme.cardElevated)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

/// Green-tinted rounded tile holding an SF Symbol — the note row icon.
struct NoteIconTile: View {
    let systemName: String
    var body: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(Theme.iconTile)
            .frame(width: 56, height: 56)
            .overlay(
                Image(systemName: systemName)
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(Theme.iconTileInk)
            )
    }
}
