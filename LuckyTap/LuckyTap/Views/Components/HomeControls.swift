import SwiftUI

/// Premium glass PLAY CTA.
struct PlayCTAButton: View {
    var title: String = "PLAY"
    var isGlowing: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Capsule()
                    .fill(Color(red: 1.0, green: 0.55, blue: 0.05).opacity(isGlowing ? 0.5 : 0.28))
                    .blur(radius: 18)
                    .scaleEffect(x: 1.06, y: 1.4)

                Capsule()
                    .fill(Color(red: 0.5, green: 0.18, blue: 0.02))
                    .offset(y: 5)

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.95, blue: 0.55),
                                Color(red: 1.0, green: 0.75, blue: 0.22),
                                Color(red: 1.0, green: 0.48, blue: 0.06),
                                Color(red: 0.82, green: 0.26, blue: 0.02)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Capsule()
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.9), Color.white.opacity(0.2), AppTheme.gold],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2.2
                    )
                    .padding(1)

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.55), Color.white.opacity(0.08), .clear],
                            startPoint: .top,
                            endPoint: UnitPoint(x: 0.5, y: 0.52)
                        )
                    )
                    .padding(.horizontal, 8)
                    .padding(.top, 5)
                    .padding(.bottom, 30)
                    .allowsHitTesting(false)

                Text(title)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color(red: 1.0, green: 0.97, blue: 0.88)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: Color(red: 0.4, green: 0.12, blue: 0).opacity(0.55), radius: 1, y: 1)
            }
            .frame(height: 62)
            .shadow(color: Color.orange.opacity(isGlowing ? 0.65 : 0.35), radius: isGlowing ? 16 : 8, y: 3)
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
            VStack(spacing: 7) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.34, green: 0.18, blue: 0.58).opacity(0.9),
                                    Color(red: 0.12, green: 0.06, blue: 0.28).opacity(0.95)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.93, blue: 0.55),
                                    Color(red: 0.95, green: 0.6, blue: 0.15),
                                    Color(red: 0.75, green: 0.45, blue: 0.95)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.6
                        )

                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.2), .clear],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                        .padding(1)

                    Image(imageName)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .shadow(color: .black.opacity(0.35), radius: 3, y: 2)
                }
                .aspectRatio(1, contentMode: .fit)
                .shadow(color: AppTheme.gold.opacity(0.22), radius: 8, y: 3)
                .shadow(color: .black.opacity(0.35), radius: 6, y: 3)

                Text(title)
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(red: 1.0, green: 0.88, blue: 0.4))
                    .shadow(color: .black.opacity(0.7), radius: 2, y: 1)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .frame(height: 26)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PressableButtonStyle())
    }
}
