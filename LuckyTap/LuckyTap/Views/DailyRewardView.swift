import SwiftUI

/// 7-day login streak — claim today's reward.
struct DailyRewardView: View {
    @EnvironmentObject private var store: GameStore
    var onClose: () -> Void

    var body: some View {
        ZStack {
            CityBackgroundView(dimOpacity: 0.42)

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        Image("ShortcutGift")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 88, height: 88)
                            .shadow(color: AppTheme.gold.opacity(0.35), radius: 10)

                        Text("Come back every day to grow your streak and earn bigger coin rewards.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28)

                        Text("Day \(store.player.dailyStreakDay) of 7")
                            .font(.system(size: 16, weight: .heavy, design: .rounded))
                            .foregroundColor(AppTheme.gold)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                            ForEach(store.player.dailyRewards) { day in
                                dailyCard(day)
                            }
                        }
                        .padding(.horizontal, 18)

                        PrimaryButton(
                            title: store.canClaimDaily ? "CLAIM TODAY'S REWARD" : "ALREADY CLAIMED",
                            gradient: LinearGradient(
                                colors: [AppTheme.neonGreen, Color(red: 0.1, green: 0.55, blue: 0.25)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        ) {
                            store.claimDailyReward()
                        }
                        .padding(.horizontal, 28)
                        .opacity(store.canClaimDaily ? 1 : 0.5)
                        .disabled(!store.canClaimDaily)

                        Text(store.canClaimDaily ? "Tap claim to collect today's coins" : "Come back tomorrow for the next day")
                            .font(.caption.bold())
                            .foregroundColor(.white.opacity(0.55))
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 36)
                }
            }
        }
    }

    private var header: some View {
        HStack {
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(Color.black.opacity(0.4)))
                    .overlay(Circle().stroke(AppTheme.gold.opacity(0.45), lineWidth: 1.2))
            }
            .buttonStyle(PressableButtonStyle())
            Spacer()
            Text("DAILY REWARD")
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundStyle(AppTheme.goldGradient)
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 18)
        .padding(.top, 8)
    }

    private func dailyCard(_ day: DailyRewardDay) -> some View {
        let current = day.day == store.player.dailyStreakDay
        let locked = day.day > store.player.dailyStreakDay
        return VStack(spacing: 8) {
            Text("Day \(day.day)")
                .font(.system(size: 11, weight: .heavy))
                .foregroundColor(AppTheme.gold)
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.black.opacity(0.4))
                    .frame(height: 64)
                if day.claimed {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppTheme.neonGreen)
                        .font(.title)
                } else if locked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.white.opacity(0.5))
                } else {
                    VStack(spacing: 2) {
                        Text("🪙")
                        Text(short(day.reward))
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(8)
        .background(current ? AppTheme.gold.opacity(0.18) : Color.black.opacity(0.28))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(current ? AppTheme.gold : AppTheme.panelStroke, lineWidth: current ? 2.2 : 1)
        )
    }

    private func short(_ value: Int) -> String {
        value >= 1000 ? "\(value / 1000)K" : "\(value)"
    }
}
