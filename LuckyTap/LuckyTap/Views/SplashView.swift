import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.82
    @State private var logoOpacity: Double = 0
    @State private var glowPulse = false
    @State private var titleOffset: CGFloat = 16
    @State private var sparkle = false

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            Circle()
                .fill(AppTheme.gold.opacity(0.12))
                .frame(width: 260, height: 260)
                .blur(radius: 50)
                .offset(x: -90, y: -180)
                .scaleEffect(glowPulse ? 1.08 : 0.92)

            Circle()
                .fill(AppTheme.neonBlue.opacity(0.14))
                .frame(width: 280, height: 280)
                .blur(radius: 55)
                .offset(x: 100, y: 200)
                .scaleEffect(glowPulse ? 0.95 : 1.1)

            VStack(spacing: 22) {
                ZStack {
                    RoundedRectangle(cornerRadius: 36, style: .continuous)
                        .fill(AppTheme.gold.opacity(0.18))
                        .frame(width: 168, height: 168)
                        .blur(radius: 18)
                        .scaleEffect(glowPulse ? 1.12 : 0.95)

                    Image("AppLogo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 148, height: 148)
                        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .stroke(AppTheme.goldGradient, lineWidth: 3)
                        )
                        .shadow(color: AppTheme.gold.opacity(0.45), radius: 18, y: 8)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                VStack(spacing: 6) {
                    HStack(spacing: 8) {
                        Text("Lucky")
                            .foregroundStyle(AppTheme.goldGradient)
                        Text("Tap")
                            .foregroundColor(.white)
                            .shadow(color: AppTheme.neonBlue.opacity(0.8), radius: 8)
                        Text("🍀")
                            .scaleEffect(sparkle ? 1.15 : 1.0)
                    }
                    .font(.system(size: 40, weight: .black, design: .rounded))

                    Text("555 SLOTS")
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .tracking(4)
                        .foregroundColor(AppTheme.gold.opacity(0.85))
                }
                .offset(y: titleOffset)
                .opacity(logoOpacity)

                ProgressView()
                    .tint(AppTheme.gold)
                    .scaleEffect(1.1)
                    .padding(.top, 8)
                    .opacity(logoOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.72)) {
                logoScale = 1
                logoOpacity = 1
                titleOffset = 0
            }
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                glowPulse = true
            }
            withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                sparkle = true
            }
        }
    }
}
