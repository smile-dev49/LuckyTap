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

            Spacer(minLength: 12)

            playButton
                .padding(.horizontal, 40)
                .opacity(appeared ? 1 : 0)
                .scaleEffect(appeared ? 1 : 0.88)

            Spacer(minLength: 16)

            shortcutsRow
                .padding(.horizontal, 14)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 22)

            Spacer(minLength: 108)
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

    // Background is provided by RootView (CityBackgroundView)


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


    private var heroStage: some View {
        ZStack {
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

            Image("HomeHero")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 8)
                .padding(.vertical, 14)
                .scaleEffect(heroPulse ? 1.02 : 1.0)
                .shadow(color: AppTheme.neonBlue.opacity(0.35), radius: 12)

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


    private var playButton: some View {
        PlayCTAButton(isGlowing: playGlow, action: onPlay)
    }

    private var shortcutsRow: some View {
        HStack(spacing: 12) {
            HomeShortcutItem(imageName: "ShortcutGift", title: "Daily Reward", action: onDailyReward)
            HomeShortcutItem(imageName: "ShortcutTrophy", title: "Missions", action: onMissions)
            HomeShortcutItem(imageName: "ShortcutSlots", title: "Lucky Bonus", action: onLuckyBonus)
            HomeShortcutItem(imageName: "ShortcutWheel", title: "Spin Wheel", action: onSpinWheel)
        }
    }
}
