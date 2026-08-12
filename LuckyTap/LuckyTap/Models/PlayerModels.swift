import Foundation

struct Mission: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let target: Int
    var progress: Int
    let reward: Int
    var claimed: Bool

    var isComplete: Bool { progress >= target }
    var progressText: String { "\(min(progress, target)) / \(target)" }
    var fraction: Double { min(1, Double(progress) / Double(max(target, 1))) }
}

struct DailyRewardDay: Identifiable, Codable, Equatable {
    let day: Int
    let reward: Int
    var claimed: Bool

    var id: Int { day }
}

struct CollectionItem: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let emoji: String
    var count: Int
    let goal: Int

    var fraction: Double { min(1, Double(count) / Double(max(goal, 1))) }
    var progressText: String { "\(count) / \(goal)" }
}

struct PlayerSnapshot: Codable, Equatable {
    var coins: Int
    var bet: Int
    var level: Int
    var xp: Int
    var xpToNext: Int
    var bestWin: Int
    var playerName: String
    var vipTitle: String
    var soundEnabled: Bool
    var hapticsEnabled: Bool
    var dailyStreakDay: Int
    var lastClaimDate: String?
    var dailyRewards: [DailyRewardDay]
    var missions: [Mission]
    var collections: [CollectionItem]
    var totalSpins: Int
    var totalWins: Int
    var tripleFiveCount: Int
    var bonusSpinsLeft: Int
    var lastBonusClaimDate: String?
    var wheelSpinsLeft: Int
    var lastWheelClaimDate: String?

    static let startingCoins = 1_100_000
    static let defaultBet = 110_000
    static let minBet = 10_000
    static let maxBet = 500_000
    static let betStep = 10_000

    static func fresh() -> PlayerSnapshot {
        PlayerSnapshot(
            coins: startingCoins,
            bet: defaultBet,
            level: 1,
            xp: 0,
            xpToNext: 500,
            bestWin: 0,
            playerName: "Player123",
            vipTitle: "VIP Rookie",
            soundEnabled: true,
            hapticsEnabled: true,
            dailyStreakDay: 1,
            lastClaimDate: nil,
            dailyRewards: (1...7).map { day in
                DailyRewardDay(day: day, reward: day * 15_000, claimed: false)
            },
            missions: [
                Mission(id: "win3", title: "Win 3 games", target: 3, progress: 0, reward: 20_000, claimed: false),
                Mission(id: "collect50k", title: "Collect 50,000 coins", target: 50_000, progress: 0, reward: 50_000, claimed: false),
                Mission(id: "triple5", title: "Get 3 Triple 5s", target: 3, progress: 0, reward: 100_000, claimed: false),
                Mission(id: "play10", title: "Play 10 times", target: 10, progress: 0, reward: 30_000, claimed: false)
            ],
            collections: [
                CollectionItem(id: "clovers", name: "CLOVERS", emoji: "🍀", count: 0, goal: 20),
                CollectionItem(id: "gems", name: "GEMS", emoji: "💎", count: 0, goal: 30),
                CollectionItem(id: "hearts", name: "HEARTS", emoji: "❤️", count: 0, goal: 20),
                CollectionItem(id: "stars", name: "STARS", emoji: "⭐", count: 0, goal: 30)
            ],
            totalSpins: 0,
            totalWins: 0,
            tripleFiveCount: 0,
            bonusSpinsLeft: 3,
            lastBonusClaimDate: nil,
            wheelSpinsLeft: 1,
            lastWheelClaimDate: nil
        )
    }
}
