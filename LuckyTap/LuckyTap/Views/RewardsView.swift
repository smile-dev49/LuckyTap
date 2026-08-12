import SwiftUI

struct RewardsView: View {
    @EnvironmentObject private var store: GameStore
    var startOnMissions: Bool = false
    @State private var showMissions = false

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "REWARDS", icon: "🎁")

            HStack(spacing: 0) {
                tabChip("DAILY REWARD", active: !showMissions) { showMissions = false }
                tabChip("MISSIONS", active: showMissions) { showMissions = true }
            }
            .padding(4)
            .background(Color.black.opacity(0.35))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 18)
            .padding(.top, 12)

            ScrollView(showsIndicators: false) {
                if showMissions {
                    missionsList
                } else {
                    dailySection
                }
            }
            .padding(.top, 14)

            Spacer(minLength: 90)
        }
        .onAppear { showMissions = startOnMissions }
        .onChange(of: startOnMissions) { _, newValue in
            showMissions = newValue
        }
    }

    private var dailySection: some View {
        VStack(spacing: 16) {
            Text("Daily Login Streak")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.75))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 18)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(store.player.dailyRewards) { day in
                        dailyCard(day)
                    }
                }
                .padding(.horizontal, 18)
            }

            PrimaryButton(
                title: store.canClaimDaily ? "CLAIM" : "COME BACK TOMORROW",
                gradient: LinearGradient(
                    colors: [AppTheme.neonGreen, Color(red: 0.1, green: 0.55, blue: 0.25)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            ) {
                store.claimDailyReward()
            }
            .padding(.horizontal, 28)
            .opacity(store.canClaimDaily ? 1 : 0.55)
            .disabled(!store.canClaimDaily)

            // Preview missions below as in design
            Text("Missions Preview")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.75))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 18)
                .padding(.top, 8)

            ForEach(store.player.missions.prefix(2)) { mission in
                missionRow(mission)
            }
            .padding(.horizontal, 18)
        }
        .padding(.bottom, 20)
    }

    private var missionsList: some View {
        VStack(spacing: 12) {
            ForEach(store.player.missions) { mission in
                missionRow(mission)
            }
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 20)
    }

    private func dailyCard(_ day: DailyRewardDay) -> some View {
        let current = day.day == store.player.dailyStreakDay
        let locked = day.day > store.player.dailyStreakDay
        return VStack(spacing: 8) {
            Text("Day \(day.day)")
                .font(.system(size: 11, weight: .heavy))
                .foregroundColor(AppTheme.gold)
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.35))
                    .frame(width: 64, height: 64)
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
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(8)
        .background(current ? AppTheme.gold.opacity(0.15) : AppTheme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(current ? AppTheme.gold : AppTheme.panelStroke, lineWidth: current ? 2.5 : 1)
        )
    }

    private func missionRow(_ mission: Mission) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(mission.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text("🪙 \(GameStore.format(mission.reward))")
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundColor(AppTheme.gold)
            }
            ProgressBarView(progress: mission.fraction)
            HStack {
                Text(mission.progressText)
                    .font(.caption.bold())
                    .foregroundColor(.white.opacity(0.65))
                Spacer()
                if mission.claimed {
                    Text("CLAIMED")
                        .font(.caption.bold())
                        .foregroundColor(AppTheme.neonGreen)
                } else if mission.isComplete {
                    Button("CLAIM") {
                        store.claimMission(mission.id)
                    }
                    .font(.caption.bold())
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppTheme.neonGreen)
                    .clipShape(Capsule())
                }
            }
        }
        .padding(14)
        .background(AppTheme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .goldBorder(cornerRadius: 14, lineWidth: 1)
    }

    private func tabChip(_ title: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .heavy))
                .foregroundColor(active ? .black : .white.opacity(0.7))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(active ? AppTheme.goldGradient : LinearGradient(colors: [.clear, .clear], startPoint: .top, endPoint: .bottom))
                .clipShape(RoundedRectangle(cornerRadius: 11))
        }
        .buttonStyle(.plain)
    }

    private func short(_ value: Int) -> String {
        if value >= 1000 { return "\(value / 1000)K" }
        return "\(value)"
    }
}
