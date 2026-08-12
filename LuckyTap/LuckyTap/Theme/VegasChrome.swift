import SwiftUI

struct VegasBackground: View {
    var body: some View {
        ZStack {
            GameTheme.backgroundGradient
                .ignoresSafeArea()

            // Neon atmosphere orbs
            Circle()
                .fill(GameTheme.neonPurple.opacity(0.42))
                .frame(width: 320, height: 320)
                .blur(radius: 70)
                .offset(x: -130, y: -260)

            Circle()
                .fill(GameTheme.neonBlue.opacity(0.30))
                .frame(width: 280, height: 280)
                .blur(radius: 55)
                .offset(x: 150, y: -60)

            Circle()
                .fill(GameTheme.neonPink.opacity(0.22))
                .frame(width: 220, height: 220)
                .blur(radius: 50)
                .offset(x: 90, y: 280)

            // Spark particles
            ForEach(0..<18, id: \.self) { i in
                Circle()
                    .fill(i % 2 == 0 ? GameTheme.neonBlue : GameTheme.goldLight)
                    .frame(width: CGFloat(2 + (i % 3)), height: CGFloat(2 + (i % 3)))
                    .opacity(0.55)
                    .offset(
                        x: CGFloat((i * 47) % 300) - 150,
                        y: CGFloat((i * 73) % 500) - 220
                    )
                    .blur(radius: 0.4)
            }

            LightningBolt()
                .fill(GameTheme.neonBlue.opacity(0.55))
                .frame(width: 36, height: 88)
                .shadow(color: GameTheme.neonBlue, radius: 10)
                .offset(x: 128, y: -190)

            LightningBolt()
                .fill(GameTheme.neonPink.opacity(0.4))
                .frame(width: 26, height: 68)
                .shadow(color: GameTheme.neonPink, radius: 8)
                .offset(x: -145, y: -130)
                .scaleEffect(x: -1, y: 1)

            VStack {
                Spacer()
                CitySilhouette()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.40, green: 0.14, blue: 0.62).opacity(0.7),
                                Color.black.opacity(0.65)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 150)
                    .overlay(alignment: .top) {
                        // Window lights
                        HStack(spacing: 18) {
                            ForEach(0..<10, id: \.self) { i in
                                VStack(spacing: 8) {
                                    ForEach(0..<3, id: \.self) { _ in
                                        RoundedRectangle(cornerRadius: 1)
                                            .fill(GameTheme.neonBlue.opacity(0.35 + Double(i % 3) * 0.1))
                                            .frame(width: 4, height: 6)
                                    }
                                }
                                .offset(y: CGFloat((i % 4) * 8))
                            }
                        }
                        .padding(.top, 28)
                        .opacity(0.8)
                    }
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

struct LightningBolt: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.55, y: 0))
        path.addLine(to: CGPoint(x: rect.width * 0.25, y: rect.height * 0.45))
        path.addLine(to: CGPoint(x: rect.width * 0.52, y: rect.height * 0.45))
        path.addLine(to: CGPoint(x: rect.width * 0.35, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width * 0.78, y: rect.height * 0.38))
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.38))
        path.closeSubpath()
        return path
    }
}

struct CitySilhouette: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: 0, y: h * 0.55))
        path.addLine(to: CGPoint(x: w * 0.08, y: h * 0.55))
        path.addLine(to: CGPoint(x: w * 0.08, y: h * 0.30))
        path.addLine(to: CGPoint(x: w * 0.16, y: h * 0.30))
        path.addLine(to: CGPoint(x: w * 0.16, y: h * 0.48))
        path.addLine(to: CGPoint(x: w * 0.25, y: h * 0.48))
        path.addLine(to: CGPoint(x: w * 0.25, y: h * 0.18))
        path.addLine(to: CGPoint(x: w * 0.34, y: h * 0.18))
        path.addLine(to: CGPoint(x: w * 0.34, y: h * 0.42))
        path.addLine(to: CGPoint(x: w * 0.45, y: h * 0.42))
        path.addLine(to: CGPoint(x: w * 0.45, y: h * 0.25))
        path.addLine(to: CGPoint(x: w * 0.55, y: h * 0.12))
        path.addLine(to: CGPoint(x: w * 0.65, y: h * 0.25))
        path.addLine(to: CGPoint(x: w * 0.65, y: h * 0.50))
        path.addLine(to: CGPoint(x: w * 0.78, y: h * 0.50))
        path.addLine(to: CGPoint(x: w * 0.78, y: h * 0.28))
        path.addLine(to: CGPoint(x: w * 0.90, y: h * 0.28))
        path.addLine(to: CGPoint(x: w * 0.90, y: h * 0.58))
        path.addLine(to: CGPoint(x: w, y: h * 0.58))
        path.addLine(to: CGPoint(x: w, y: h))
        path.closeSubpath()
        return path
    }
}

struct LuckyTapLogo: View {
    var size: CGFloat = 1.0

    var body: some View {
        VStack(spacing: -8 * size) {
            Text("Lucky")
                .font(.system(size: 46 * size, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.white, GameTheme.goldLight, GameTheme.gold],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: GameTheme.neonBlue.opacity(0.95), radius: 7)
                .shadow(color: .black.opacity(0.55), radius: 2, y: 3)

            Text("Tap")
                .font(.system(size: 52 * size, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: GameTheme.neonBlue, radius: 9)
                .shadow(color: .black.opacity(0.5), radius: 2, y: 3)
                .rotationEffect(.degrees(-5))
        }
        .overlay(alignment: .topTrailing) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 20 * size, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.green.opacity(0.95), Color(red: 0.1, green: 0.7, blue: 0.25)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .rotationEffect(.degrees(28))
                .offset(x: 24 * size, y: 4 * size)
                .shadow(color: .green.opacity(0.75), radius: 5)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Lucky Tap")
    }
}

/// Simplified mascot inspired by the branding (SwiftUI shapes only — not a bitmap).
struct MascotView: View {
    var body: some View {
        ZStack {
            // Body / hoodie
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.35, green: 0.25, blue: 0.75),
                            Color(red: 0.18, green: 0.12, blue: 0.45)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 110, height: 130)
                .offset(y: 36)

            // Star badge
            Image(systemName: "star.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(GameTheme.gold)
                .offset(y: 48)
                .shadow(color: GameTheme.gold.opacity(0.7), radius: 4)

            // Head
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.86, blue: 0.72),
                            Color(red: 0.95, green: 0.74, blue: 0.55)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 78, height: 78)
                .offset(y: -28)
                .overlay(
                    // Hair
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.45, green: 0.28, blue: 0.14),
                                    Color(red: 0.28, green: 0.15, blue: 0.08)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 84, height: 34)
                        .offset(y: -58)
                )
                .overlay(
                    // Eyes + smile
                    VStack(spacing: 6) {
                        HStack(spacing: 16) {
                            Circle().fill(Color.white).frame(width: 12, height: 12)
                                .overlay(Circle().fill(Color.black).frame(width: 6, height: 6))
                            Circle().fill(Color.white).frame(width: 12, height: 12)
                                .overlay(Circle().fill(Color.black).frame(width: 6, height: 6))
                        }
                        Capsule()
                            .stroke(Color(red: 0.7, green: 0.2, blue: 0.2), lineWidth: 2.5)
                            .frame(width: 22, height: 10)
                            .offset(y: 2)
                    }
                    .offset(y: -24)
                )

            // Raised fist
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.86, blue: 0.72),
                            Color(red: 0.95, green: 0.74, blue: 0.55)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 28, height: 28)
                .overlay(
                    Capsule()
                        .fill(Color(red: 0.25, green: 0.15, blue: 0.55))
                        .frame(width: 16, height: 28)
                        .offset(y: 18)
                )
                .offset(x: 58, y: -10)
                .shadow(color: .black.opacity(0.3), radius: 3, y: 2)
        }
        .frame(width: 150, height: 180)
        .accessibilityLabel("Lucky Tap mascot")
    }
}

struct GoldCoinIcon: View {
    var size: CGFloat = 28

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [GameTheme.goldLight, GameTheme.gold, GameTheme.goldDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: GameTheme.gold.opacity(0.7), radius: 4)

            Circle()
                .stroke(Color(red: 0.65, green: 0.4, blue: 0.05), lineWidth: max(1.5, size * 0.06))
                .frame(width: size * 0.72, height: size * 0.72)

            Text("$")
                .font(.system(size: size * 0.45, weight: .black, design: .rounded))
                .foregroundStyle(Color(red: 0.55, green: 0.32, blue: 0.02))
        }
    }
}
