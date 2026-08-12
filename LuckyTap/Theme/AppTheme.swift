import SwiftUI

enum AppTheme {
    static let deepPurple = Color(red: 0.16, green: 0.07, blue: 0.32)
    static let navy = Color(red: 0.07, green: 0.05, blue: 0.18)
    static let midPurple = Color(red: 0.38, green: 0.20, blue: 0.58)
    static let panelPurple = Color(red: 0.28, green: 0.14, blue: 0.48)
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.28)
    static let goldDark = Color(red: 0.88, green: 0.52, blue: 0.08)
    static let neonGreen = Color(red: 0.25, green: 0.95, blue: 0.35)
    static let neonBlue = Color(red: 0.30, green: 0.78, blue: 1.0)
    static let hotPink = Color(red: 1.0, green: 0.35, blue: 0.55)
    static let softWhite = Color.white.opacity(0.92)
    static let panel = Color.white.opacity(0.08)
    static let panelStroke = Color.white.opacity(0.18)

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.06, green: 0.04, blue: 0.16),
                Color(red: 0.14, green: 0.07, blue: 0.30),
                Color(red: 0.10, green: 0.05, blue: 0.22)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var goldGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 1.0, green: 0.96, blue: 0.62), gold, goldDark],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var playGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.82, blue: 0.28),
                Color(red: 1.0, green: 0.58, blue: 0.08),
                Color(red: 0.95, green: 0.38, blue: 0.05)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var panelGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.32, green: 0.16, blue: 0.55),
                Color(red: 0.22, green: 0.10, blue: 0.42),
                Color(red: 0.14, green: 0.08, blue: 0.30)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct GoldBorderModifier: ViewModifier {
    var cornerRadius: CGFloat = 18
    var lineWidth: CGFloat = 2

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(AppTheme.goldGradient, lineWidth: lineWidth)
            )
    }
}

struct PressableButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.94

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.28, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

extension View {
    func goldBorder(cornerRadius: CGFloat = 18, lineWidth: CGFloat = 2) -> some View {
        modifier(GoldBorderModifier(cornerRadius: cornerRadius, lineWidth: lineWidth))
    }

    func softGlow(_ color: Color, radius: CGFloat = 12) -> some View {
        shadow(color: color.opacity(0.55), radius: radius, y: 0)
    }
}
