import SwiftUI

enum GameTheme {
    // MARK: - Background
    static let backgroundTop = Color(red: 0.18, green: 0.08, blue: 0.42)
    static let backgroundMid = Color(red: 0.10, green: 0.05, blue: 0.28)
    static let backgroundBottom = Color(red: 0.04, green: 0.02, blue: 0.12)
    static let panelFill = Color(red: 0.12, green: 0.06, blue: 0.30).opacity(0.85)

    // MARK: - Neon / Gold
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.25)
    static let goldLight = Color(red: 1.0, green: 0.93, blue: 0.55)
    static let goldDark = Color(red: 0.78, green: 0.55, blue: 0.08)
    static let neonPink = Color(red: 1.0, green: 0.35, blue: 0.75)
    static let neonBlue = Color(red: 0.25, green: 0.70, blue: 1.0)
    static let neonPurple = Color(red: 0.55, green: 0.25, blue: 0.95)

    // MARK: - Buttons
    static let orangeButtonTop = Color(red: 1.0, green: 0.72, blue: 0.18)
    static let orangeButtonBottom = Color(red: 0.95, green: 0.40, blue: 0.05)
    static let greenButtonTop = Color(red: 0.45, green: 1.0, blue: 0.35)
    static let greenButtonBottom = Color(red: 0.05, green: 0.72, blue: 0.18)
    static let greenButtonEdge = Color(red: 0.02, green: 0.45, blue: 0.10)

    // MARK: - Reels
    static let reelBackground = Color.white
    static let reelNumber = Color(red: 0.90, green: 0.08, blue: 0.12)
    static let reelFrame = gold

    // MARK: - Text
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.75)
    static let textGold = gold

    // MARK: - Gradients
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [backgroundTop, backgroundMid, backgroundBottom],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var goldGradient: LinearGradient {
        LinearGradient(
            colors: [goldLight, gold, goldDark],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var orangeButtonGradient: LinearGradient {
        LinearGradient(
            colors: [orangeButtonTop, orangeButtonBottom],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var greenButtonGradient: LinearGradient {
        LinearGradient(
            colors: [greenButtonTop, greenButtonBottom],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var panelGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.22, green: 0.10, blue: 0.48).opacity(0.9),
                Color(red: 0.08, green: 0.04, blue: 0.22).opacity(0.95)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Shared modifiers

struct NeonGlow: ViewModifier {
    var color: Color
    var radius: CGFloat = 10

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.85), radius: radius / 2)
            .shadow(color: color.opacity(0.55), radius: radius)
    }
}

struct GoldBorder: ViewModifier {
    var cornerRadius: CGFloat = 16
    var lineWidth: CGFloat = 2.5

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(GameTheme.goldGradient, lineWidth: lineWidth)
            )
    }
}

extension View {
    func neonGlow(_ color: Color, radius: CGFloat = 10) -> some View {
        modifier(NeonGlow(color: color, radius: radius))
    }

    func goldBorder(cornerRadius: CGFloat = 16, lineWidth: CGFloat = 2.5) -> some View {
        modifier(GoldBorder(cornerRadius: cornerRadius, lineWidth: lineWidth))
    }
}
