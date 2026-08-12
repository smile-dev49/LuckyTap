import SwiftUI

/// Premium glass PLAY CTA.
struct PlayCTAButton: View {
    var title: String = "PLAY"
    var isGlowing: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                // Soft outer bloom
                Capsule()
                    .fill(Color(red: 1.0, green: 0.55, blue: 0.05).opacity(isGlowing ? 0.45 : 0.25))
                    .blur(radius: 16)
                    .scaleEffect(x: 1.04, y: 1.35)

                // Depth plate
                Capsule()
                    .fill(Color(red: 0.55, green: 0.22, blue: 0.02))
                    .offset(y: 4)

                // Main body
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.92, blue: 0.45),
                                Color(red: 1.0, green: 0.72, blue: 0.18),
                                Color(red: 1.0, green: 0.48, blue: 0.05),
                                Color(red: 0.85, green: 0.28, blue: 0.02)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                // Inner rim
                Capsule()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.85),
                                Color.white.opacity(0.15),
                                AppTheme.gold.opacity(0.7)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2.2
                    )
                    .padding(1)

                // Glass sheen
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.55),
                                Color.white.opacity(0.12),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: UnitPoint(x: 0.5, y: 0.55)
                        )
                    )
                    .padding(.horizontal, 6)
                    .padding(.top, 4)
                    .padding(.bottom, 28)
                    .allowsHitTesting(false)

                // Title
                Text(title)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color(red: 1.0, green: 0.96, blue: 0.85)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: Color(red: 0.45, green: 0.15, blue: 0).opacity(0.55), radius: 1, y: 1)
                    .shadow(color: Color.orange.opacity(0.35), radius: 6)
            }
            .frame(height: 64)
            .shadow(color: Color(red: 1.0, green: 0.5, blue: 0.05).opacity(isGlowing ? 0.7 : 0.35), radius: isGlowing ? 18 : 10, y: 4)
        }
        .buttonStyle(PressableButtonStyle(scale: 0.96))
    }
}

struct HomeShortcutItem: View {
    let imageName: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    // Soft glow behind tile
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(AppTheme.gold.opacity(0.18))
                        .blur(radius: 10)
                        .scaleEffect(1.05)

                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.28, green: 0.14, blue: 0.48).opacity(0.72),
                                    Color(red: 0.10, green: 0.05, blue: 0.24).opacity(0.82)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 1.0, green: 0.92, blue: 0.55),
                                            Color(red: 1.0, green: 0.65, blue: 0.2),
                                            Color(red: 0.85, green: 0.55, blue: 0.95)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.8
                                )
                        )
                        .shadow(color: .black.opacity(0.35), radius: 8, y: 4)

                    // Top glass
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.22), .clear],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                        .padding(1)

                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(10)
                        .shadow(color: .black.opacity(0.35), radius: 4, y: 2)
                }
                .frame(height: 72)

                Text(title)
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(red: 1.0, green: 0.95, blue: 0.7), AppTheme.gold],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .black.opacity(0.6), radius: 2, y: 1)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(height: 26)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PressableButtonStyle())
    }
}
