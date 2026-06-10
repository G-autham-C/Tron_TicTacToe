import SwiftUI

enum TronTheme {
    static let background = Color(red: 0.020, green: 0.039, blue: 0.055)
    static let gridLine = Color(red: 0.051, green: 0.129, blue: 0.216)
    static let playerX = Color(red: 0, green: 0.812, blue: 1.0)
    static let playerO = Color(red: 1.0, green: 0.420, blue: 0.208)
    static let winHighlight = Color(red: 0.878, green: 0.969, blue: 1.0)
    static let statusText = Color.white

    static let titleFont: Font = .system(size: 28, weight: .bold, design: .monospaced)
    static let bodyFont: Font = .system(size: 16, weight: .medium, design: .monospaced)
    static let statusFont: Font = .system(size: 18, weight: .semibold, design: .monospaced)
}

struct NeonGlowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.9), radius: radius / 2)
            .shadow(color: color.opacity(0.4), radius: radius)
    }
}

extension View {
    func neonGlow(color: Color, radius: CGFloat = 8) -> some View {
        modifier(NeonGlowModifier(color: color, radius: radius))
    }
}
