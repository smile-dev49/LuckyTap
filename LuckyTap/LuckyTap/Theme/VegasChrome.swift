import SwiftUI

struct VegasBackground: View {
    var body: some View {
        ZStack {
            GameTheme.backgroundGradient
                .ignoresSafeArea()

            OptionalAssetImage(name: "game_background", contentMode: .fill) {
                Color.clear
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .opacity(0.55)
            .ignoresSafeArea()
            .allowsHitTesting(false)

            // Neon atmosphere
            Circle()
                .fill(GameTheme.neonPurple.opacity(0.40))
                .frame(width: 320, height: 320)
                .blur(radius: 70)
                .offset(x: -130, y: -260)

            Circle()
                .fill(GameTheme.neonBlue.opacity(0.28))
                .frame(width: 260, height: 260)
                .blur(radius: 55)
                .offset(x: 150, y: -40)

            Circle()
                .fill(GameTheme.neonPink.opacity(0.20))
                .frame(width: 220, height: 220)
                .blur(radius: 50)
                .offset(x: 90, y: 280)

            // Lightning accents
            LightningBolt()
                .stroke(GameTheme.neonBlue.opacity(0.55), lineWidth: 2)
                .frame(width: 40, height: 90)
                .blur(radius: 0.5)
                .shadow(color: GameTheme.neonBlue, radius: 8)
                .offset(x: 130, y: -180)

            LightningBolt()
                .stroke(GameTheme.neonPink.opacity(0.4), lineWidth: 2)
                .frame(width: 28, height: 70)
                .shadow(color: GameTheme.neonPink, radius: 6)
                .offset(x: -140, y: -120)
                .scaleEffect(x: -1, y: 1)

            VStack {
                Spacer()
                CitySilhouette()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.35, green: 0.12, blue: 0.55).opacity(0.55),
                                Color.black.opacity(0.55)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 140)
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
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.45))
        path.addLine(to: CGPoint(x: rect.width * 0.35, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width * 0.75, y: rect.height * 0.4))
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.4))
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
        VStack(spacing: -6 * size) {
            Text("Lucky")
                .font(.system(size: 44 * size, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.white,
                            GameTheme.goldLight,
                            GameTheme.gold
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: GameTheme.neonBlue.opacity(0.9), radius: 6)
                .shadow(color: .black.opacity(0.55), radius: 2, y: 3)

            Text("Tap")
                .font(.system(size: 50 * size, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: GameTheme.neonBlue, radius: 8)
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
                .offset(x: 22 * size, y: 2 * size)
                .shadow(color: .green.opacity(0.7), radius: 5)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Lucky Tap")
    }
}
