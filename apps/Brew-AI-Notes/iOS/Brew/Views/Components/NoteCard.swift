import SwiftUI

/// A row in the notes list: icon tile, title, time, lock glyph.
struct NoteCard: View {
    let note: Note

    var body: some View {
        HStack(spacing: 14) {
            NoteIconTile(systemName: icon)
            VStack(alignment: .leading, spacing: 3) {
                Text(note.displayTitle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Theme.ink)
                    .lineLimit(1)
                Text(note.createdAt.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.inkSecondary)
            }
            Spacer()
            Image(systemName: "lock.fill")
                .font(.system(size: 14))
                .foregroundStyle(Theme.inkTertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .cardBackground()
    }

    private var icon: String {
        switch note.status {
        case .enhanced: return "doc.text"
        case .enhancing: return "sparkles"
        case .transcriptionFailed: return "exclamationmark.triangle"
        default: return "waveform"
        }
    }
}
