import Foundation

struct GameState: Codable, Equatable {
    var coinBalance: Int
    var selectedBet: Int
    var lastDailyRewardDate: Date?
    var dailyRewardStreak: Int
    var soundEnabled: Bool
    var vibrationEnabled: Bool
    var bestWin: Int

    static let `default` = GameState(
        coinBalance: GameConfiguration.startingBalance,
        selectedBet: GameConfiguration.defaultBet,
        lastDailyRewardDate: nil,
        dailyRewardStreak: 0,
        soundEnabled: true,
        vibrationEnabled: true,
        bestWin: 0
    )

    mutating func resetProgress() {
        coinBalance = GameConfiguration.startingBalance
        selectedBet = GameConfiguration.defaultBet
        lastDailyRewardDate = nil
        dailyRewardStreak = 0
        bestWin = 0
    }
}
