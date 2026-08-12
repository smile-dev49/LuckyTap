import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()

    private let defaults: UserDefaults
    private let stateKey = "lucky_tap_game_state"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadState() -> GameState {
        guard let data = defaults.data(forKey: stateKey) else {
            return .default
        }

        do {
            return try decoder.decode(GameState.self, from: data)
        } catch {
            return .default
        }
    }

    func saveState(_ state: GameState) {
        do {
            let data = try encoder.encode(state)
            defaults.set(data, forKey: stateKey)
        } catch {
            // Silently ignore persistence failures for MVP.
        }
    }

    func reset() {
        saveState(.default)
    }
}
