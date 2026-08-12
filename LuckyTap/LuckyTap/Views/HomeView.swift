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
    @State private var jackpotPulse = false
    @State private var mascotBounce = false
    @State private var playGlow = false
    @State private var shimmer = false

    var body: some View {
        ZStack {
            ambientBackground

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 18)
                    .padding(.top, 6)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : -12)

                Spacer(minLength: 10)

                brandTitle
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)

                Spacer(minLength: 14)

                jackpotCard
                    .padding(.horizontal, 18)
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.94)

                Spacer(minLength: 22)

                playButton
                    .padding(.horizontal, 36)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 16)

                Spacer(minLength: 22)

                shortcutsRow
                    .padding(.horizontal, 14)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)

                Spacer(minLength: 100)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.65, dampingFraction: 0.82)) {
                appeared = true
            }
            withAnimation(.easeInOut(duration: 1.35).repeatForever(autoreverses: true)) {
                jackpotPulse = true
            }
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                mascotBounce = true
            }
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                playGlow = true
            }
            withAnimation(.linear(duration: 2.4).repeatForever(autoreverses: false)) {
                shimmer = true
            }
        }
    }

    // MARK: - Layers

    private var ambientBackground: some View {
        ZStack {
            Circle()
                .fill(AppTheme.gold.opacity(0.10))
                .frame(width: 220, height: 220)
                .blur(radius: 40)
                .offset(x: -110, y: -220)
                .scaleEffect(playGlow ? 1.08 : 0.95)

            Circle()
                .fill(AppTheme.neonBlue.opacity(0.10))
                .frame(width: 240, height: 240)
                .blur(radius: 45)
                .offset(x: 120, y: 80)
                .scaleEffect(playGlow ? 0.96 : 1.08)

            Circle()
                .fill(AppTheme.hotPink.opacity(0.07))
                .frame(width: 180, height: 180)
                .blur(radius: 35)
                .offset(x: -40, y: 260)
        }
        .allowsHitTesting(false)
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            CoinBadge(amount: store.player.coins, showPlus: true) {
                store.showToast("Coins are earned in-game")
            }

            Spacer()

            Button(action: onSettings) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.92))
                    .frame(width: 42, height: 42)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.38))
                            .overlay(Circle().stroke(AppTheme.gold.opacity(0.55), lineWidth: 1.4))
                    )
                    .shadow(color: .black.opacity(0.35), radius: 6, y: 2)
            }
            .buttonStyle(PressableButtonStyle())
        }
    }

    private var brandTitle: some View {
        HStack(spacing: 7) {
            Text("Lucky")
                .foregroundStyle(AppTheme.goldGradient)
                .shadow(color: AppTheme.gold.opacity(0.45), radius: 8, y: 2)
            Text("Tap")
                .foregroundColor(.white)
                .shadow(color: AppTheme.neonBlue.opacity(0.7), radius: 10)
            Text("🍀")
                .font(.system(size: 26))
                .shadow(color: AppTheme.neonGreen.opacity(0.5), radius: 6)
                .scaleEffect(mascotBounce ? 1.08 : 1.0)
        }
        .font(.system(size: 40, weight: .black, design: .rounded))
    }

    private var jackpotCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(AppTheme.panelGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    AppTheme.gold.opacity(0.95),
                                    AppTheme.gold.opacity(0.35),
                                    AppTheme.gold.opacity(0.85)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2.2
                        )
                )
                .shadow(color: AppTheme.gold.opacity(jackpotPulse ? 0.35 : 0.15), radius: jackpotPulse ? 18 : 10, y: 6)

            // Soft city bars
            HStack(alignment: .bottom, spacing: 9) {
                ForEach(0..<9, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(Color.white.opacity(0.05 + Double(i % 3) * 0.025))
                        .frame(width: 22, height: CGFloat(36 + (i % 5) * 16))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 14)
            .padding(.horizontal, 16)
            .allowsHitTesting(false)

            // Shimmer sweep
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.clear, Color.white.opacity(0.10), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .offset(x: shimmer ? 180 : -180)
                .mask(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .allowsHitTesting(false)

            HStack(spacing: 18) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [AppTheme.neonBlue.opacity(0.55), AppTheme.neonBlue.opacity(0.12)],
                                    center: .center,
                                    startRadius: 8,
                                    endRadius: 58
                                )
                            )
                            .frame(width: 108, height: 108)
                            .scaleEffect(mascotBounce ? 1.04 : 0.98)

                        Circle()
                            .stroke(AppTheme.gold.opacity(0.45), lineWidth: 1.5)
                            .frame(width: 108, height: 108)

                        Text("😎")
                            .font(.system(size: 58))
                            .offset(y: mascotBounce ? -3 : 2)
                    }

                    Text("Ready?")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                }

                VStack(spacing: 10) {
                    Text("JACKPOT")
                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                        .tracking(2)
                        .foregroundColor(AppTheme.gold)
                        .shadow(color: AppTheme.gold.opacity(0.5), radius: 4)

                    HStack(spacing: 7) {
                        ForEach(0..<3, id: \.self) { index in
                            SymbolTile(symbol: .five, size: 48)
                                .scaleEffect(jackpotPulse && index == 1 ? 1.05 : 1)
                                .shadow(color: Color.red.opacity(0.25), radius: 4)
                        }
                    }

                    Text("555")
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(red: 1, green: 0.35, blue: 0.35), Color(red: 0.85, green: 0.05, blue: 0.15)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: Color.red.opacity(jackpotPulse ? 0.7 : 0.35), radius: jackpotPulse ? 10 : 4)
                        .scaleEffect(jackpotPulse ? 1.06 : 1.0)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 20)
        }
        .frame(height: 210)
    }

    private var playButton: some View {
        Button(action: onPlay) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppTheme.playGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.white.opacity(0.35), lineWidth: 1.5)
                    )
                    .shadow(color: AppTheme.goldDark.opacity(playGlow ? 0.7 : 0.4), radius: playGlow ? 16 : 8, y: 5)

                // Top highlight
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.28), .clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                    .allowsHitTesting(false)

                Text("PLAY")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.25), radius: 2, y: 1)
            }
            .frame(height: 60)
        }
        .buttonStyle(PressableButtonStyle(scale: 0.96))
    }

    private var shortcutsRow: some View {
        HStack(spacing: 10) {
            shortcutCard(emoji: "🎁", title: "Daily Reward", tint: AppTheme.hotPink, action: onDailyReward)
            shortcutCard(emoji: "🏆", title: "Missions", tint: AppTheme.gold, action: onMissions)
            shortcutCard(emoji: "🎰", title: "Lucky Bonus", tint: AppTheme.neonBlue, action: onLuckyBonus)
            shortcutCard(emoji: "🎡", title: "Spin Wheel", tint: AppTheme.midPurple, action: onSpinWheel)
        }
    }

    private func shortcutCard(emoji: String, title: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 9) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [tint.opacity(0.28), Color.black.opacity(0.35)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(AppTheme.gold.opacity(0.65), lineWidth: 1.5)
                        )
                        .shadow(color: tint.opacity(0.25), radius: 8, y: 3)

                    Text(emoji)
                        .font(.system(size: 28))
                }
                .frame(height: 62)

                Text(title)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.88))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(height: 28)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PressableButtonStyle())
    }
}
