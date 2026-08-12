import Foundation

enum SlotEngine {
    private static var bag: [SlotSymbol] = {
        var items: [SlotSymbol] = []
        for symbol in SlotSymbol.allCases {
            items.append(contentsOf: Array(repeating: symbol, count: symbol.weight))
        }
        return items
    }()

    static func randomSymbol() -> SlotSymbol {
        bag.randomElement() ?? .clover
    }

    static func spin() -> [SlotSymbol] {
        [randomSymbol(), randomSymbol(), randomSymbol()]
    }

    /// While spinning, keep producing symbols for reel animation.
    static func tickSymbol() -> SlotSymbol {
        randomSymbol()
    }
}
