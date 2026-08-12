import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: GameStore
    var onPlay: () -> Void
    var onSettings: () -> Void
    var onDailyReward: () -> Void
    var onMissions: () -> Void
    var onLuckyBonus: () -> Void
    var onSpinWheel: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                CoinBadge(amount: store.player.coins, showPlus: true) {
                    store.showToast("Coins are earned in-game")
                }
                Spacer()
                Button(action: onSettings) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(10)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)

            Spacer(minLength: 8)

            // Brand + hero
            VStack(spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("Lucky")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundStyle(AppTheme.goldGradient)
                    Text("Tap")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: AppTheme.neonBlue, radius: 8)
                    Text("🍀")
                        .font(.system(size: 28))
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.2, green: 0.1, blue: 0.45),
                                    Color(red: 0.35, green: 0.15, blue: 0.55),
                                    Color(red: 0.12, green: 0.08, blue: 0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            // faux city lights
                            VStack {
                                Spacer()
                                HStack(spacing: 10) {
                                    ForEach(0..<8, id: \.self) { i in
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color.white.opacity(0.08 + Double(i % 3) * 0.04))
                                            .frame(width: 28, height: CGFloat(30 + (i % 4) * 18))
                                    }
                                }
                                .padding(.bottom, 12)
                            }
                        )
                        .goldBorder(cornerRadius: 22, lineWidth: 2.5)

                    HStack(spacing: 8) {
                        VStack(spacing: 4) {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.neonBlue.opacity(0.25))
                                    .frame(width: 110, height: 110)
                                Text("😎")
                                    .font(.system(size: 64))
                            }
                            Text("Ready?")
                                .font(.caption.bold())
                                .foregroundColor(.white.opacity(0.8))
                        }

                        VStack(spacing: 6) {
                            Text("JACKPOT")
                                .font(.system(size: 11, weight: .heavy))
                                .foregroundColor(AppTheme.gold)
                            HStack(spacing: 4) {
                                ForEach(0..<3, id: \.self) { _ in
                                    SymbolTile(symbol: .five, size: 42)
                                }
                            }
                            Text("555")
                                .font(.system(size: 20, weight: .black, design: .rounded))
                                .foregroundColor(Color.red)
                        }
                    }
                    .padding()
                }
                .frame(height: 200)
                .padding(.horizontal, 18)
            }

            Spacer(minLength: 16)

            PrimaryButton(title: "PLAY", height: 58, action: onPlay)
                .padding(.horizontal, 40)

            Spacer(minLength: 18)

            HStack(spacing: 12) {
                shortcut("🎁", "Daily Reward", onDailyReward)
                shortcut("🏆", "Missions", onMissions)
                shortcut("🎰", "Lucky Bonus", onLuckyBonus)
                shortcut("🎡", "Spin Wheel", onSpinWheel)
            }
            .padding(.horizontal, 16)

            Spacer(minLength: 90)
        }
    }

    private func shortcut(_ emoji: String, _ title: String, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 28))
                    .frame(width: 56, height: 56)
                    .background(AppTheme.panel)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .goldBorder(cornerRadius: 14, lineWidth: 1.5)
                Text(title)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(height: 28)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
