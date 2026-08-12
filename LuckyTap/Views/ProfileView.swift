import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "PROFILE", icon: "👑")

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.neonBlue.opacity(0.3))
                                .frame(width: 72, height: 72)
                            Text("😎")
                                .font(.system(size: 40))
                        }
                        .overlay(Circle().stroke(AppTheme.gold, lineWidth: 2))

                        VStack(alignment: .leading, spacing: 6) {
                            Text(store.player.playerName)
                                .font(.system(size: 20, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            Text(store.player.vipTitle)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(AppTheme.goldGradient)
                                .clipShape(Capsule())

                            HStack(spacing: 8) {
                                ProgressBarView(
                                    progress: Double(store.player.xp) / Double(max(store.player.xpToNext, 1)),
                                    fill: AppTheme.midPurple
                                )
                                Text("Lv \(store.player.level)")
                                    .font(.system(size: 11, weight: .heavy))
                                    .foregroundColor(AppTheme.gold)
                            }
                            Text("\(store.player.xp) / \(store.player.xpToNext)")
                                .font(.caption2.bold())
                                .foregroundColor(.white.opacity(0.55))
                        }
                    }
                    .padding(16)
                    .background(AppTheme.panel)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .goldBorder(cornerRadius: 18)
                    .padding(.horizontal, 18)

                    HStack(spacing: 12) {
                        statBox(title: "TOTAL COINS", value: GameStore.format(store.player.coins))
                        statBox(title: "BEST WIN", value: GameStore.format(store.player.bestWin))
                    }
                    .padding(.horizontal, 18)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("COLLECTION")
                            .font(.system(size: 14, weight: .heavy))
                            .foregroundColor(AppTheme.gold)

                        ForEach(store.player.collections) { item in
                            HStack(spacing: 12) {
                                Text(item.emoji)
                                    .font(.title2)
                                    .frame(width: 40)
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(item.name)
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text(item.progressText)
                                            .font(.system(size: 12, weight: .heavy))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    ProgressBarView(progress: item.fraction, fill: AppTheme.neonBlue)
                                }
                            }
                            .padding(12)
                            .background(Color.black.opacity(0.28))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(16)
                    .background(AppTheme.panel)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .goldBorder(cornerRadius: 18)
                    .padding(.horizontal, 18)
                }
                .padding(.top, 12)
                .padding(.bottom, 110)
            }
        }
    }

    private func statBox(title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .heavy))
                .foregroundColor(.white.opacity(0.65))
            Text(value)
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundColor(AppTheme.gold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppTheme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .goldBorder(cornerRadius: 14, lineWidth: 1.5)
    }
}
