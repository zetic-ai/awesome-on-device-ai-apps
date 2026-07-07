import CoreText
import Foundation
import UIKit

/// Output formats a note can be exported / shared as.
enum ExportFormat: String, CaseIterable, Identifiable {
    case markdown = "Markdown"
    case plainText = "Plain Text"
    case pdf = "PDF"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .markdown: return "doc.plaintext"
        case .plainText: return "textformat"
        case .pdf: return "doc.richtext"
        }
    }

    var fileExtension: String {
        switch self {
        case .markdown: return "md"
        case .plainText: return "txt"
        case .pdf: return "pdf"
        }
    }
}

/// Builds shareable files from a note. Markdown and plain text are written as
/// UTF-8; PDF is paginated with Core Text so long notes flow across pages.
enum NoteExporter {
    /// Returns a temp-file URL for the note in the requested format, or nil on failure.
    static func export(_ note: Note, as format: ExportFormat) -> URL? {
        let url = tempURL(for: note, format: format)
        do {
            switch format {
            case .markdown:
                try markdown(for: note).data(using: .utf8)?.write(to: url)
            case .plainText:
                try plainText(for: note).data(using: .utf8)?.write(to: url)
            case .pdf:
                try pdfData(for: note).write(to: url)
            }
            return url
        } catch {
            return nil
        }
    }

    /// Plain string for "Copy to clipboard".
    static func copyText(for note: Note) -> String { plainText(for: note) }

    // MARK: - Content

    static func markdown(for note: Note) -> String {
        var out = "# \(note.displayTitle)\n\n"
        out += "*\(dateLine(note))*\n\n"
        if let enhanced = note.enhancedNote, !enhanced.isEmpty {
            out += enhanced + "\n\n"
        }
        if !note.transcript.isEmpty {
            out += "---\n\n# Transcript\n\n\(note.transcript)\n"
        }
        return out
    }

    static func plainText(for note: Note) -> String {
        var out = "\(note.displayTitle)\n\(dateLine(note))\n\n"
        if let enhanced = note.enhancedNote, !enhanced.isEmpty {
            out += strip(enhanced) + "\n\n"
        }
        if !note.transcript.isEmpty {
            out += "TRANSCRIPT\n\n\(note.transcript)\n"
        }
        return out
    }

    private static func dateLine(_ note: Note) -> String {
        note.createdAt.formatted(date: .complete, time: .shortened)
    }

    /// Removes common markdown markers for a clean plain-text rendering.
    private static func strip(_ markdown: String) -> String {
        markdown.components(separatedBy: .newlines).map { line -> String in
            var l = line
            while l.hasPrefix("#") { l.removeFirst() }
            l = l.trimmingCharacters(in: .whitespaces)
            for b in ["- ", "* ", "• "] where l.hasPrefix(b) { l = "• " + l.dropFirst(b.count) }
            return l.replacingOccurrences(of: "**", with: "")
                    .replacingOccurrences(of: "__", with: "")
        }.joined(separator: "\n")
    }

    // MARK: - PDF

    private static func pdfData(for note: Note) -> Data {
        let pageSize = CGSize(width: 612, height: 792) // US Letter
        let margin: CGFloat = 54
        let textRect = CGRect(x: margin, y: margin,
                              width: pageSize.width - margin * 2,
                              height: pageSize.height - margin * 2)

        let attributed = attributedString(for: note)
        let framesetter = CTFramesetterCreateWithAttributedString(attributed)

        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        return renderer.pdfData { ctx in
            var rangeStart = 0
            let total = attributed.length
            let path = CGPath(rect: textRect, transform: nil)

            repeat {
                ctx.beginPage()
                let cgContext = ctx.cgContext
                // Flip coordinates so Core Text draws top-down.
                cgContext.textMatrix = .identity
                cgContext.translateBy(x: 0, y: pageSize.height)
                cgContext.scaleBy(x: 1, y: -1)

                let frame = CTFramesetterCreateFrame(
                    framesetter,
                    CFRangeMake(rangeStart, 0),
                    path, nil
                )
                CTFrameDraw(frame, cgContext)
                let visible = CTFrameGetVisibleStringRange(frame)
                rangeStart += visible.length
                if visible.length == 0 { break } // guard against non-progress
            } while rangeStart < total
        }
    }

    private static func attributedString(for note: Note) -> NSAttributedString {
        let result = NSMutableAttributedString()
        let titleFont = UIFont(name: "TimesNewRomanPS-BoldMT", size: 26)
            ?? .systemFont(ofSize: 26, weight: .bold)
        let headerFont = UIFont(name: "TimesNewRomanPS-BoldMT", size: 17)
            ?? .systemFont(ofSize: 17, weight: .bold)
        let bodyFont = UIFont.systemFont(ofSize: 12)
        let metaFont = UIFont.italicSystemFont(ofSize: 11)

        result.append(NSAttributedString(string: note.displayTitle + "\n",
                                         attributes: [.font: titleFont]))
        result.append(NSAttributedString(string: dateLine(note) + "\n\n",
                                         attributes: [.font: metaFont, .foregroundColor: UIColor.gray]))

        func appendBody(_ text: String) {
            for line in text.components(separatedBy: .newlines) {
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                if trimmed.hasPrefix("# ") {
                    result.append(NSAttributedString(string: "\n" + trimmed.dropFirst(2) + "\n",
                                                     attributes: [.font: headerFont]))
                } else if let bullet = ["- ", "* ", "• "].first(where: { trimmed.hasPrefix($0) }) {
                    result.append(NSAttributedString(string: "•  " + trimmed.dropFirst(bullet.count) + "\n",
                                                     attributes: [.font: bodyFont]))
                } else {
                    result.append(NSAttributedString(string: trimmed + "\n",
                                                     attributes: [.font: bodyFont]))
                }
            }
        }

        if let enhanced = note.enhancedNote, !enhanced.isEmpty {
            appendBody(enhanced)
        }
        if !note.transcript.isEmpty {
            result.append(NSAttributedString(string: "\nTranscript\n",
                                             attributes: [.font: headerFont]))
            result.append(NSAttributedString(string: note.transcript + "\n",
                                             attributes: [.font: bodyFont]))
        }
        return result
    }

    // MARK: - Files

    private static func tempURL(for note: Note, format: ExportFormat) -> URL {
        let safeName = note.displayTitle
            .components(separatedBy: CharacterSet.alphanumerics.union(.whitespaces).inverted)
            .joined()
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: " ", with: "-")
        let base = safeName.isEmpty ? "note" : safeName
        return FileManager.default.temporaryDirectory
            .appendingPathComponent("\(base).\(format.fileExtension)")
    }
}
