import SwiftUI

/// Lightweight renderer for the AI note's markdown: H1 headers (serif, bold),
/// bullets, and body text. Avoids AttributedString's weak H1 styling and keeps
/// the editorial look of the reference.
struct MarkdownView: View {
    let markdown: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                row(for: line)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var lines: [String] {
        markdown.components(separatedBy: .newlines)
    }

    @ViewBuilder
    private func row(for raw: String) -> some View {
        let line = raw.trimmingCharacters(in: .whitespaces)
        if line.isEmpty {
            Color.clear.frame(height: 2)
        } else if line.hasPrefix("# ") {
            Text(inline(String(line.dropFirst(2))))
                .font(Theme.serif(22, weight: .bold))
                .foregroundStyle(Theme.ink)
                .padding(.top, 10)
        } else if line.hasPrefix("## ") {
            Text(inline(String(line.dropFirst(3))))
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Theme.ink)
                .padding(.top, 6)
        } else if let bullet = bulletContent(line) {
            HStack(alignment: .top, spacing: 8) {
                Text("•")
                    .foregroundStyle(Theme.inkSecondary)
                Text(inline(bullet))
                    .foregroundStyle(Theme.ink)
            }
            .font(.system(size: 17))
        } else {
            Text(inline(line))
                .font(.system(size: 17))
                .foregroundStyle(Theme.ink)
        }
    }

    private func bulletContent(_ line: String) -> String? {
        for prefix in ["- ", "* ", "• ", "  - ", "  * "] {
            if line.hasPrefix(prefix) { return String(line.dropFirst(prefix.count)) }
        }
        return nil
    }

    /// Parse inline bold/italic via AttributedString where available.
    private func inline(_ text: String) -> AttributedString {
        (try? AttributedString(markdown: text)) ?? AttributedString(text)
    }
}
