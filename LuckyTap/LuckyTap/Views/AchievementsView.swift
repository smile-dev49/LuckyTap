import SwiftUI

struct AchievementBadge: Identifiable {
    let id: String
    let title: String
    let detail: String
    let emoji: String
    let unlocked: Bool
    let progressText: String
    let fraction: Double
}

/// Lifetime badges / milestones (different from daily missions).
struct AchievementsView: View {
    @EnvironmentObject private var store: GameStore

    private var badges: [AchievementBadge] {
        let p = store.player
        return [
            AchievementBadge(
                id: "first_spin",
                title: "First Spin",
                detail: "Play the slots once",
                emoji: "🎰",
                unlocked: p.totalSpins >= 1,
                progressText: "\(min(p.totalSpins, 1))/1",
                fraction: min(1, Double(p.totalSpins) / 1)
            ),
            AchievementBadge(
                id: "spin_master",
                title: "Spin Master",
                detail: "Reach 50 total spins",
                emoji: "🔄",
                unlocked: p.totalSpins >= 50,
                progressText: "\(min(p.totalSpins, 50))/50",
                fraction: min(1, Double(p.totalSpins) / 50)
            ),
            AchievementBadge(
                id: "winner",
                title: "Lucky Winner",
                detail: "Win 10 rounds",
                emoji: "🏅",
                unlocked: p.totalWins >= 10,
                progressText: "\(min(p.totalWins, 10))/10",
                fraction: min(1, Double(p.totalWins) / 10)
            ),
            AchievementBadge(
                id: "jackpot",
                title: "555 Jackpot",
                detail: "Hit Triple 5 at least once",
                emoji: "5️⃣",
                unlocked: p.tripleFiveCount >= 1,
                progressText: "\(min(p.tripleFiveCount, 1))/1",
                fraction: min(1, Double(p.tripleFiveCount) / 1)
            ),
            AchievementBadge(
                id: "jackpot_king",
                title: "Jackpot King",
                detail: "Hit Triple 5 three times",
                emoji: "👑",
                unlocked: p.tripleFiveCount >= 3,
                progressText: "\(min(p.tripleFiveCount, 3))/3",
                fraction: min(1, Double(p.tripleFiveCount) / 3)
            ),
            AchievementBadge(
                id: "big_win",
                title: "Big Win",
                detail: "Best single win of 500,000+",
                emoji: "💥",
                unlocked: p.bestWin >= 500_000,
                progressText: "\(GameStore.format(min(p.bestWin, 500_000)))/500,000",
                fraction: min(1, Double(p.bestWin) / 500_000)
            ),
            AchievementBadge(
                id: "level5",
                title: "Rising Star",
                detail: "Reach Level 5",
                emoji: "⭐",
                unlocked: p.level >= 5,
                progressText: "Lv \(min(p.level, 5))/5",
                fraction: min(1, Double(p.level) / 5)
            ),
            AchievementBadge(
                id: "collector",
                title: "Symbol Collector",
                detail: "Own 40 collected symbols",
                emoji: "📦",
                unlocked: totalCollected >= 40,
                progressText: "\(min(totalCollected, 40))/40",
                fraction: min(1, Double(totalCollected) / 40)
            )
        ]
    }

    private var totalCollected: Int {
        store.player.collections.reduce(0) { $0 + $1.count }
    }

    private var unlockedCount: Int {
        badges.filter(\.unlocked).count
    }

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "ACHIEVEMENTS", icon: "🏆")

            HStack {
                Text("Badges unlocked")
                    .font(.subheadline.bold())
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                Text("\(unlockedCount)/\(badges.count)")
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundColor(AppTheme.gold)
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)

            ProgressBarView(progress: Double(unlockedCount) / Double(max(badges.count, 1)), fill: AppTheme.gold)
                .padding(.horizontal, 18)
                .padding(.top, 8)

            Text("Lifetime milestones from your play history — separate from daily missions.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.55))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 18)
                .padding(.top, 8)

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    ForEach(badges) { badge in
                        badgeCard(badge)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 110)
            }
        }
    }

    private func badgeCard(_ badge: AchievementBadge) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(badge.emoji)
                    .font(.system(size: 28))
                    .grayscale(badge.unlocked ? 0 : 1)
                    .opacity(badge.unlocked ? 1 : 0.45)
                Spacer()
                Image(systemName: badge.unlocked ? "checkmark.seal.fill" : "lock.fill")
                    .foregroundColor(badge.unlocked ? AppTheme.neonGreen : .white.opacity(0.35))
            }

            Text(badge.title)
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundColor(badge.unlocked ? AppTheme.gold : .white.opacity(0.75))

            Text(badge.detail)
                .font(.caption)
                .foregroundColor(.white.opacity(0.55))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            ProgressBarView(
                progress: badge.fraction,
                fill: badge.unlocked ? AppTheme.neonGreen : AppTheme.neonBlue,
                height: 8
            )
            Text(badge.progressText)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.black.opacity(badge.unlocked ? 0.45 : 0.32))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(badge.unlocked ? AppTheme.gold.opacity(0.7) : AppTheme.panelStroke, lineWidth: badge.unlocked ? 1.6 : 1)
        )
    }
}
