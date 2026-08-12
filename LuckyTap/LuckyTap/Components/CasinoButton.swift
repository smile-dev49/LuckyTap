import SwiftUI

enum CasinoButtonStyle {
    case orange
    case green
    case goldOutline
}

struct CasinoButton: View {
    let title: String
    var style: CasinoButtonStyle = .orange
    var isEnabled: Bool = true
    var fontSize: CGFloat = 28
    var horizontalPadding: CGFloat = 40
    var verticalPadding: CGFloat = 16
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.35), radius: 1, y: 1)
                .frame(maxWidth: style == .green ? nil : .infinity)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .background(background)
                .clipShape(Capsule())
                .overlay(overlayStroke)
                .shadow(color: glowColor.opacity(isEnabled ? 0.85 : 0.25), radius: 12, y: 2)
                .shadow(color: glowColor.opacity(isEnabled ? 0.45 : 0.1), radius: 22)
                .opacity(isEnabled ? 1 : 0.55)
        }
        .buttonStyle(ScalePressStyle())
        .disabled(!isEnabled)
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .orange:
            GameTheme.orangeButtonGradient
        case .green:
            GameTheme.greenButtonGradient
        case .goldOutline:
            LinearGradient(
                colors: [
                    Color(red: 0.25, green: 0.12, blue: 0.45),
                    Color(red: 0.10, green: 0.05, blue: 0.22)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    @ViewBuilder
    private var overlayStroke: some View {
        switch style {
        case .orange:
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.55), GameTheme.goldDark.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 2
                )
        case .green:
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.5), GameTheme.greenButtonEdge],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 3
                )
        case .goldOutline:
            Capsule()
                .stroke(GameTheme.goldGradient, lineWidth: 2)
        }
    }

    private var glowColor: Color {
        switch style {
        case .orange: return GameTheme.orangeButtonTop
        case .green: return GameTheme.greenButtonTop
        case .goldOutline: return GameTheme.gold
        }
    }
}

struct ScalePressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct RoundCasinoButton: View {
    let title: String
    var size: CGFloat = 110
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(GameTheme.greenButtonGradient)
                    .frame(width: size, height: size)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.65), GameTheme.greenButtonEdge],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 4
                            )
                    )
                    .shadow(color: GameTheme.greenButtonTop.opacity(isEnabled ? 0.9 : 0.25), radius: 16)
                    .shadow(color: GameTheme.greenButtonBottom.opacity(isEnabled ? 0.55 : 0.15), radius: 28)

                // Inner highlight
                Circle()
                    .stroke(Color.white.opacity(0.25), lineWidth: 2)
                    .frame(width: size * 0.78, height: size * 0.78)
                    .offset(y: -size * 0.04)

                Text(title)
                    .font(.system(size: size * 0.28, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.4), radius: 2, y: 1)
            }
            .opacity(isEnabled ? 1 : 0.5)
            .scaleEffect(isEnabled ? 1 : 0.96)
        }
        .buttonStyle(ScalePressStyle())
        .disabled(!isEnabled)
        .accessibilityLabel(title)
    }
}
