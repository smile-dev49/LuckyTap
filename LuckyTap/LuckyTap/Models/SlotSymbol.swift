import Foundation

enum SlotSymbol: String, CaseIterable, Codable, Identifiable, Hashable {
    case five
    case clover
    case star
    case diamond
    case heart

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .five: return "5️⃣"
        case .clover: return "🍀"
        case .star: return "⭐"
        case .diamond: return "💎"
        case .heart: return "❤️"
        }
    }

    var displayName: String {
        switch self {
        case .five: return "5"
        case .clover: return "Clover"
        case .star: return "Star"
        case .diamond: return "Gem"
        case .heart: return "Heart"
        }
    }

    var weight: Int {
        switch self {
        case .five: return 8
        case .clover: return 22
        case .star: return 20
        case .diamond: return 18
        case .heart: return 20
        }
    }

    var collectionKey: String? {
        switch self {
        case .clover: return "clovers"
        case .star: return "stars"
        case .diamond: return "gems"
        case .heart: return "hearts"
        case .five: return nil
        }
    }
}

struct SpinResult: Equatable {
    let reels: [SlotSymbol]
    let multiplier: Double
    let payout: Int
    let isJackpot: Bool
    let label: String

    var isWin: Bool { payout > 0 }
}

enum PayTable {
    static let maxMultiplier: Double = 50

    static func evaluate(reels: [SlotSymbol], bet: Int) -> SpinResult {
        guard reels.count == 3 else {
            return SpinResult(reels: reels, multiplier: 0, payout: 0, isJackpot: false, label: "")
        }

        let a = reels[0], b = reels[1], c = reels[2]

        if a == .five && b == .five && c == .five {
            let mult = 50.0
            return SpinResult(reels: reels, multiplier: mult, payout: Int(Double(bet) * mult), isJackpot: true, label: "555 JACKPOT!")
        }

        if a == b && b == c {
            let mult: Double
            switch a {
            case .diamond: mult = 20
            case .star: mult = 15
            case .heart: mult = 12
            case .clover: mult = 10
            case .five: mult = 50
            }
            return SpinResult(reels: reels, multiplier: mult, payout: Int(Double(bet) * mult), isJackpot: false, label: "TRIPLE \(a.displayName.uppercased())!")
        }

        let fiveCount = reels.filter { $0 == .five }.count
        if fiveCount == 2 {
            let mult = 3.0
            return SpinResult(reels: reels, multiplier: mult, payout: Int(Double(bet) * mult), isJackpot: false, label: "DOUBLE 5!")
        }

        if a == b || b == c || a == c {
            let mult = 1.5
            return SpinResult(reels: reels, multiplier: mult, payout: Int(Double(bet) * mult), isJackpot: false, label: "PAIR WIN!")
        }

        return SpinResult(reels: reels, multiplier: 0, payout: 0, isJackpot: false, label: "TRY AGAIN")
    }
}
