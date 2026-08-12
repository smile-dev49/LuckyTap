import Foundation

enum GameConfiguration {
    // MARK: - Coins
    static let startingBalance: Int = 100_000

    // MARK: - Bets
    static let betOptions: [Int] = [100, 500, 1_000, 2_500, 5_000, 10_000]
    static let defaultBet: Int = 1_000

    // MARK: - Reels
    static let reelValues: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    static let specialSymbol: Int = 5
    static let reelCount: Int = 3

    // MARK: - Payouts
    static let lucky555Multiplier: Int = 50
    static let anyTripleMultiplier: Int = 10
    static let pairMultiplier: Int = 2
    static let maxWinBannerAmount: Int = 500_000

    // MARK: - Daily Rewards (Day 1...7)
    static let dailyRewards: [Int] = [
        1_000,
        2_000,
        3_000,
        5_000,
        10_000,
        15_000,
        25_000
    ]

    // MARK: - Animation timing (seconds)
    static let reelSpinInterval: Double = 0.08
    static let reel1StopDelay: Double = 0.9
    static let reel2StopDelay: Double = 1.5
    static let reel3StopDelay: Double = 2.1
}
