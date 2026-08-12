import Foundation

enum WinType: Equatable {
    case none
    case pair
    case triple
    case lucky555

    var isWin: Bool {
        self != .none
    }
}

struct GameResult: Equatable {
    let reels: [Int]
    let bet: Int
    let winAmount: Int
    let winType: WinType

    var isLucky555: Bool {
        winType == .lucky555
    }

    var isWin: Bool {
        winType.isWin
    }

    static let empty = GameResult(
        reels: [5, 5, 5],
        bet: 0,
        winAmount: 0,
        winType: .none
    )
}
