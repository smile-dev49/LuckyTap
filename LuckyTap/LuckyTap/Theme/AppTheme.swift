import SwiftUI

enum AppTheme {
    static let deepPurple = Color(red: 0.18, green: 0.08, blue: 0.35)
    static let navy = Color(red: 0.08, green: 0.06, blue: 0.22)
    static let midPurple = Color(red: 0.35, green: 0.18, blue: 0.55)
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.25)
    static let goldDark = Color(red: 0.85, green: 0.55, blue: 0.08)
    static let neonGreen = Color(red: 0.25, green: 0.95, blue: 0.35)
    static let neonBlue = Color(red: 0.25, green: 0.75, blue: 1.0)
    static let hotPink = Color(red: 1.0, green: 0.35, blue: 0.55)
    static let softWhite = Color.white.opacity(0.92)
    static let panel = Color.white.opacity(0.08)
    static let panelStroke = Color.white.opacity(0.18)

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [navy, deepPurple, Color(red: 0.25, green: 0.1, blue: 0.4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var goldGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 1.0, green: 0.95, blue: 0.55), gold, goldDark],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var playGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 1.0, green: 0.78, blue: 0.2), Color(red: 1.0, green: 0.45, blue: 0.05)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct GoldBorderModifier: ViewModifier {
    var cornerRadius: CGFloat = 18
    var lineWidth: CGFloat = 2

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(AppTheme.goldGradient, lineWidth: lineWidth)
            )
    }
}

extension View {
    func goldBorder(cornerRadius: CGFloat = 18, lineWidth: CGFloat = 2) -> some View {
        modifier(GoldBorderModifier(cornerRadius: cornerRadius, lineWidth: lineWidth))
    }
}
