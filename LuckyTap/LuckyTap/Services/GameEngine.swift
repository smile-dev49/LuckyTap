import Foundation

final class GameEngine {
    func spin(bet: Int) -> GameResult {
        let reels = (0..<GameConfiguration.reelCount).map { _ in
            GameConfiguration.reelValues.randomElement() ?? GameConfiguration.specialSymbol
        }
        return evaluate(reels: reels, bet: bet)
    }

    func evaluate(reels: [Int], bet: Int) -> GameResult {
        guard reels.count == GameConfiguration.reelCount else {
            return GameResult(reels: reels, bet: bet, winAmount: 0, winType: .none)
        }

        let a = reels[0]
        let b = reels[1]
        let c = reels[2]
        let special = GameConfiguration.specialSymbol

        if a == special && b == special && c == special {
            return GameResult(
                reels: reels,
                bet: bet,
                winAmount: bet * GameConfiguration.lucky555Multiplier,
                winType: .lucky555
            )
        }

        if a == b && b == c {
            return GameResult(
                reels: reels,
                bet: bet,
                winAmount: bet * GameConfiguration.anyTripleMultiplier,
                winType: .triple
            )
        }

        if a == b || b == c || a == c {
            return GameResult(
                reels: reels,
                bet: bet,
                winAmount: bet * GameConfiguration.pairMultiplier,
                winType: .pair
            )
        }

        return GameResult(reels: reels, bet: bet, winAmount: 0, winType: .none)
    }
}
