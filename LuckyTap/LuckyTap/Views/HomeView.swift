import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: GameStore
    var onPlay: () -> Void
    var onSettings: () -> Void
    var onDailyReward: () -> Void
    var onMissions: () -> Void
    var onLuckyBonus: () -> Void
    var onSpinWheel: () -> Void

    @State private var appeared = false
    @State private var heroPulse = false
    @State private var playGlow = false
    @State private var cloverSpin = false
    @State private var marqueeFlash = false

    var body: some View {
        ZStack {
            cityBackground

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : -14)

                Spacer(minLength: 6)

                logoBlock
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.9)

                Spacer(minLength: 8)

                heroStage
                    .padding(.horizontal, 12)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 18)

                Spacer(minLength: 18)

                playButton
                    .padding(.horizontal, 44)
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.88)

                Spacer(minLength: 18)

                shortcutsRow
                    .padding(.horizontal, 12)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 22)

                Spacer(minLength: 96)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                appeared = true
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                heroPulse = true
            }
            withAnimation(.easeInOut(duration: 1.25).repeatForever(autoreverses: true)) {
                playGlow = true
            }
            withAnimation(.easeInOut(duration: 0.55).repeatForever(autoreverses: true)) {
                marqueeFlash = true
            }
            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                cloverSpin = true
            }
        }
    }

    // MARK: - Background

    private var cityBackground: some View {
        GeometryReader { geo in
            ZStack {
                Image("HomeBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()

                // Smooth readability washes (no flat purple block)
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.02, blue: 0.14).opacity(0.55),
                        Color.clear,
                        Color(red: 0.08, green: 0.03, blue: 0.18).opacity(0.35)
                    ],
                    startPoint: .top,
                    endPoint: .center
                )

                LinearGradient(
                    colors: [
                        Color.clear,
                        Color(red: 0.06, green: 0.02, blue: 0.16).opacity(0.72),
                        Color(red: 0.04, green: 0.01, blue: 0.12).opacity(0.92)
                    ],
                    startPoint: .center,
                    endPoint: .bottom
                )

                // Soft violet mist for blend
                RadialGradient(
                    colors: [Color(red: 0.45, green: 0.2, blue: 0.85).opacity(0.18), .clear],
                    center: .top,
                    startRadius: 20,
                    endRadius: 320
                )
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Top

    private var topBar: some View {
        HStack {
            CoinBadge(amount: store.player.coins, showPlus: true) {
                store.showToast("Coins are earned in-game")
            }

            Spacer()

            Button(action: onSettings) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.35, green: 0.18, blue: 0.55), Color(red: 0.15, green: 0.08, blue: 0.28)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 42, height: 42)
                    Circle()
                        .stroke(AppTheme.goldGradient, lineWidth: 1.6)
                        .frame(width: 42, height: 42)
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(AppTheme.goldGradient)
                }
                .shadow(color: AppTheme.gold.opacity(0.35), radius: 8)
            }
            .buttonStyle(PressableButtonStyle())
        }
    }

    // MARK: - Logo (stacked like design)

    private var logoBlock: some View {
        VStack(spacing: -6) {
            Text("Lucky")
                .font(.system(size: 46, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.98, blue: 0.75),
                            AppTheme.gold,
                            Color(red: 1.0, green: 0.55, blue: 0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.55), radius: 2, y: 2)
                .shadow(color: AppTheme.gold.opacity(0.55), radius: 12)

            HStack(alignment: .center, spacing: 6) {
                Text("Tap")
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: AppTheme.neonBlue, radius: 10)
                    .shadow(color: AppTheme.neonBlue.opacity(0.8), radius: 18)

                Text("🍀")
                    .font(.system(size: 30))
                    .shadow(color: AppTheme.neonGreen.opacity(0.7), radius: 8)
                    .rotationEffect(.degrees(cloverSpin ? 8 : -8))
                    .scaleEffect(cloverSpin ? 1.1 : 0.95)
            }
        }
    }

    // MARK: - Hero (marked area)

    private var heroStage: some View {
        ZStack {
            // Outer neon frame
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(red: 0.08, green: 0.04, blue: 0.18).opacity(0.55))
                .background(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .opacity(0.55)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.9, blue: 0.4),
                                    Color(red: 1.0, green: 0.55, blue: 0.1),
                                    Color(red: 1.0, green: 0.85, blue: 0.35)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2.5
                        )
                )
                .shadow(color: AppTheme.gold.opacity(heroPulse ? 0.55 : 0.25), radius: heroPulse ? 22 : 12, y: 4)
                .shadow(color: Color.purple.opacity(0.45), radius: 16, y: 8)

            // Marquee bulbs along top edge
            VStack {
                HStack(spacing: 7) {
                    ForEach(0..<14, id: \.self) { i in
                        Circle()
                            .fill(
                                (marqueeFlash ? i % 2 == 0 : i % 2 == 1)
                                ? Color(red: 1.0, green: 0.92, blue: 0.35)
                                : Color(red: 1.0, green: 0.65, blue: 0.15).opacity(0.45)
                            )
                            .frame(width: 7, height: 7)
                            .shadow(
                                color: Color.yellow.opacity(marqueeFlash && i % 2 == 0 ? 0.9 : 0.2),
                                radius: 3
                            )
                    }
                }
                .padding(.top, 10)
                Spacer()
            }

            // Hero artwork
            Image("HomeHero")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 8)
                .padding(.vertical, 14)
                .scaleEffect(heroPulse ? 1.02 : 1.0)
                .shadow(color: AppTheme.neonBlue.opacity(0.35), radius: 12)

            // Bottom jackpot ribbon
            VStack {
                Spacer()
                HStack(spacing: 8) {
                    Text("✨")
                    Text("WIN BIG WITH 555")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                        .tracking(1.2)
                    Text("✨")
                }
                .foregroundColor(AppTheme.gold)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.55))
                        .overlay(Capsule().stroke(AppTheme.gold.opacity(0.5), lineWidth: 1))
                )
                .padding(.bottom, 12)
            }
        }
        .frame(height: 230)
    }

    // MARK: - PLAY

    private var playButton: some View {
        Button(action: onPlay) {
            ZStack {
                Capsule()
                    .fill(AppTheme.playGradient)
                    .overlay(
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.7), Color.white.opacity(0.15), AppTheme.gold],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: Color(red: 1.0, green: 0.55, blue: 0.05).opacity(playGlow ? 0.85 : 0.45), radius: playGlow ? 22 : 12, y: 4)
                    .shadow(color: AppTheme.gold.opacity(0.4), radius: 8, y: 2)

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.42), Color.white.opacity(0.05), .clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                    .padding(3)
                    .allowsHitTesting(false)

                Text("PLAY")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.35), radius: 2, y: 1)
                    .shadow(color: Color.orange.opacity(0.5), radius: 6)
            }
            .frame(height: 62)
        }
        .buttonStyle(PressableButtonStyle(scale: 0.95))
    }

    // MARK: - Shortcuts

    private var shortcutsRow: some View {
        HStack(spacing: 10) {
            shortcutCard(emoji: "🎁", title: "Daily Reward", action: onDailyReward)
            shortcutCard(emoji: "🏆", title: "Missions", action: onMissions)
            shortcutCard(emoji: "🎰", title: "Lucky Bonus", action: onLuckyBonus)
            shortcutCard(emoji: "🎡", title: "Spin Wheel", action: onSpinWheel)
        }
    }

    private func shortcutCard(emoji: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.32, green: 0.14, blue: 0.55).opacity(0.85),
                                    Color(red: 0.12, green: 0.06, blue: 0.28).opacity(0.9)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(AppTheme.goldGradient, lineWidth: 1.6)
                        )
                        .shadow(color: AppTheme.gold.opacity(0.22), radius: 8, y: 3)

                    // Glass highlight
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.18), .clear],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                        .padding(1)

                    Text(emoji)
                        .font(.system(size: 30))
                        .shadow(color: .black.opacity(0.35), radius: 3, y: 2)
                }
                .frame(height: 64)

                Text(title)
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .foregroundStyle(AppTheme.goldGradient)
                    .shadow(color: .black.opacity(0.5), radius: 2)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(height: 26)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PressableButtonStyle())
    }
}
