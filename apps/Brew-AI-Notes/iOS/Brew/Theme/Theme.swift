import SwiftUI

/// Visual language for Brew — a warm, paper-like palette with a serif display
/// face, matching the reference screenshots.
enum Theme {
    // Backgrounds
    static let canvas = Color(hex: 0xF4F3EE)      // app background (cream)
    static let card = Color(hex: 0xECEBE4)        // resting card fill
    static let cardElevated = Color(hex: 0xFBFAF6) // sheets / floating bars
    static let iconTile = Color(hex: 0xDCE3CB)    // green-tinted icon square
    static let iconTileInk = Color(hex: 0x6E7B4E)

    // Text
    static let ink = Color(hex: 0x1B1B19)
    static let inkSecondary = Color(hex: 0x6F6E69)
    static let inkTertiary = Color(hex: 0x9C9B95)

    // Accents
    static let accent = Color(hex: 0x32342E)      // near-black pills / FAB
    static let recording = Color(hex: 0x7BB661)   // recording level green

    // Serif display font (New York via .serif design)
    static func serif(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
}

extension Color {
    init(hex: UInt32, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

// MARK: - Reusable card style

struct CardBackground: ViewModifier {
    var fill: Color = Theme.card
    var cornerRadius: CGFloat = 20
    func body(content: Content) -> some View {
        content
            .background(fill)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

extension View {
    func cardBackground(fill: Color = Theme.card, cornerRadius: CGFloat = 20) -> some View {
        modifier(CardBackground(fill: fill, cornerRadius: cornerRadius))
    }
}
