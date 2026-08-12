import Foundation
import Combine
import SwiftUI

@MainActor
final class GameViewModel: ObservableObject {
    // MARK: - Published state
    @Published private(set) var coinBalance: Int
    @Published var selectedBet: Int
    @Published private(set) var bestWin: Int
    @Published var soundEnabled: Bool
    @Published var vibrationEnabled: Bool

    @Published private(set) var displayedReels: [Int] = [5, 5, 5]
    @Published private(set) var isSpinning = false
    @Published private(set) var spinningReels: [Bool] = [false, false, false]
    @Published private(set) var totalWin: Int = 0
    @Published private(set) var lastResult: GameResult = .empty
    @Published private(set) var showLucky555 = false
    @Published private(set) var winPulse = false

    @Published private(set) var dailyRewardStreak: Int
    @Published private(set) var lastDailyRewardDate: Date?
    @Published private(set) var canClaimDailyReward = false

    // MARK: - Dependencies
    private let engine: GameEngine
    private let persistence: PersistenceManager
    private let sound: SoundManager
    private let haptics: HapticManager

    private var pendingResult: GameResult?
    private var spinTask: Task<Void, Never>?

    init(
        engine: GameEngine = GameEngine(),
        persistence: PersistenceManager = .shared,
        sound: SoundManager = .shared,
        haptics: HapticManager = .shared
    ) {
        self.engine = engine
        self.persistence = persistence
        self.sound = sound
        self.haptics = haptics

        let state = persistence.loadState()
        coinBalance = max(0, state.coinBalance)
        selectedBet = Self.clampedBet(state.selectedBet, balance: state.coinBalance)
        bestWin = max(0, state.bestWin)
        soundEnabled = state.soundEnabled
        vibrationEnabled = state.vibrationEnabled
        dailyRewardStreak = max(0, state.dailyRewardStreak)
        lastDailyRewardDate = state.lastDailyRewardDate

        sound.setEnabled(soundEnabled)
        haptics.setEnabled(vibrationEnabled)
        refreshDailyRewardAvailability()
    }

    // MARK: - Computed

    var formattedBalance: String {
        Self.formatCoins(coinBalance)
    }

    var canAffordBet: Bool {
        coinBalance >= selectedBet && selectedBet > 0
    }

    var canIncreaseBet: Bool {
        guard let next = nextBetOption(ascending: true) else { return false }
        return next <= coinBalance
    }

    var canDecreaseBet: Bool {
        nextBetOption(ascending: false) != nil
    }

    var dailyRewards: [Int] {
        GameConfiguration.dailyRewards
    }

    var currentRewardDayIndex: Int {
        if hasClaimedToday {
            return max(0, (dailyRewardStreak - 1) % dailyRewards.count)
        }
        if dailyRewardStreak <= 0 || isStreakBroken {
            return 0
        }
        return dailyRewardStreak % dailyRewards.count
    }

    var hasClaimedToday: Bool {
        guard let last = lastDailyRewardDate else { return false }
        return Calendar.current.isDateInToday(last)
    }

    private var isStreakBroken: Bool {
        guard let last = lastDailyRewardDate else { return false }
        let calendar = Calendar.current
        if calendar.isDateInToday(last) || calendar.isDateInYesterday(last) {
            return false
        }
        return true
    }

    // MARK: - Bet controls

    func increaseBet() {
        guard !isSpinning, let next = nextBetOption(ascending: true), next <= coinBalance else { return }
        selectedBet = next
        playUIFeedback()
        save()
    }

    func decreaseBet() {
        guard !isSpinning, let prev = nextBetOption(ascending: false) else { return }
        selectedBet = prev
        playUIFeedback()
        save()
    }

    // MARK: - TAP gameplay

    func tap() {
        guard !isSpinning else { return }
        guard canAffordBet else { return }

        playUIFeedback()
        sound.play(.buttonTap)

        coinBalance = max(0, coinBalance - selectedBet)
        totalWin = 0
        showLucky555 = false
        winPulse = false
        lastResult = .empty

        let result = engine.spin(bet: selectedBet)
        pendingResult = result
        isSpinning = true
        spinningReels = [true, true, true]

        sound.play(.reelSpin)
        save()

        spinTask?.cancel()
        spinTask = Task { [weak self] in
            await self?.runReelAnimation(finalReels: result.reels)
        }
    }

    private func runReelAnimation(finalReels: [Int]) async {
        let values = GameConfiguration.reelValues
        var tick = 0

        let start = Date()
        let stopDelays = [
            GameConfiguration.reel1StopDelay,
            GameConfiguration.reel2StopDelay,
            GameConfiguration.reel3StopDelay
        ]

        while !Task.isCancelled {
            let elapsed = Date().timeIntervalSince(start)
            var reels = displayedReels
            var spinning = spinningReels
            var stoppedAny = false

            for index in 0..<GameConfiguration.reelCount where spinning[index] {
                let offset = (tick + index * 3) % values.count
                reels[index] = values[offset]
            }
            tick += 1

            for index in 0..<GameConfiguration.reelCount {
                if spinning[index] && elapsed >= stopDelays[index] {
                    spinning[index] = false
                    reels[index] = finalReels[index]
                    stoppedAny = true
                    sound.play(.reelStop)
                    haptics.reelStop()
                }
            }

            displayedReels = reels
            if stoppedAny || spinning != spinningReels {
                spinningReels = spinning
            }

            if spinning.allSatisfy({ !$0 }) {
                break
            }

            try? await Task.sleep(nanoseconds: UInt64(GameConfiguration.reelSpinInterval * 1_000_000_000))
        }

        guard !Task.isCancelled else { return }
        finishSpin()
    }

    private func finishSpin() {
        guard let result = pendingResult else {
            isSpinning = false
            return
        }

        lastResult = result
        totalWin = result.winAmount

        if result.winAmount > 0 {
            coinBalance += result.winAmount
            if result.winAmount > bestWin {
                bestWin = result.winAmount
            }

            withAnimation(.spring(response: 0.45, dampingFraction: 0.55)) {
                winPulse = true
            }

            if result.isLucky555 {
                showLucky555 = true
                sound.play(.lucky555)
                haptics.lucky555()
            } else {
                sound.play(.normalWin)
                haptics.win()
            }
        }

        if selectedBet > coinBalance {
            selectedBet = Self.clampedBet(selectedBet, balance: coinBalance)
        }

        isSpinning = false
        pendingResult = nil
        save()

        if showLucky555 {
            Task {
                try? await Task.sleep(nanoseconds: 2_500_000_000)
                withAnimation {
                    showLucky555 = false
                }
            }
        }
    }

    // MARK: - Daily reward

    func refreshDailyRewardAvailability() {
        canClaimDailyReward = !hasClaimedToday
    }

    @discardableResult
    func claimDailyReward() -> Int {
        refreshDailyRewardAvailability()
        guard canClaimDailyReward else { return 0 }

        let dayIndex: Int
        if dailyRewardStreak <= 0 || isStreakBroken {
            dayIndex = 0
            dailyRewardStreak = 1
        } else {
            dayIndex = dailyRewardStreak % dailyRewards.count
            dailyRewardStreak += 1
        }

        let reward = dailyRewards[dayIndex]
        coinBalance += reward
        lastDailyRewardDate = Date()
        canClaimDailyReward = false

        playUIFeedback()
        sound.play(.normalWin)
        if vibrationEnabled {
            haptics.win()
        }
        save()
        return reward
    }

    func dayStatus(for dayIndex: Int) -> DailyDayStatus {
        if hasClaimedToday {
            let claimedCount = ((dailyRewardStreak - 1) % dailyRewards.count) + 1
            if dayIndex < claimedCount {
                return .claimed
            }
            return .locked
        }

        if dailyRewardStreak <= 0 || isStreakBroken {
            return dayIndex == 0 ? .available : .locked
        }

        let nextIndex = dailyRewardStreak % dailyRewards.count
        if dayIndex < nextIndex {
            return .claimed
        }
        if dayIndex == nextIndex {
            return .available
        }
        return .locked
    }

    // MARK: - Settings

    func setSoundEnabled(_ enabled: Bool) {
        soundEnabled = enabled
        sound.setEnabled(enabled)
        playUIFeedback()
        save()
    }

    func setVibrationEnabled(_ enabled: Bool) {
        vibrationEnabled = enabled
        haptics.setEnabled(enabled)
        if enabled {
            haptics.tap()
        }
        save()
    }

    func resetGame() {
        spinTask?.cancel()
        spinTask = nil
        isSpinning = false
        spinningReels = [false, false, false]
        pendingResult = nil
        displayedReels = [5, 5, 5]
        totalWin = 0
        lastResult = .empty
        showLucky555 = false
        winPulse = false

        var state = GameState.default
        state.soundEnabled = soundEnabled
        state.vibrationEnabled = vibrationEnabled
        persistence.saveState(state)

        coinBalance = state.coinBalance
        selectedBet = state.selectedBet
        bestWin = state.bestWin
        dailyRewardStreak = 0
        lastDailyRewardDate = nil
        canClaimDailyReward = true
    }

    // MARK: - Persistence helpers

    func save() {
        let state = GameState(
            coinBalance: coinBalance,
            selectedBet: selectedBet,
            lastDailyRewardDate: lastDailyRewardDate,
            dailyRewardStreak: dailyRewardStreak,
            soundEnabled: soundEnabled,
            vibrationEnabled: vibrationEnabled,
            bestWin: bestWin
        )
        persistence.saveState(state)
    }

    private func playUIFeedback() {
        sound.play(.buttonTap)
        haptics.tap()
    }

    private func nextBetOption(ascending: Bool) -> Int? {
        let options = GameConfiguration.betOptions
        guard let index = options.firstIndex(of: selectedBet) else {
            return ascending ? options.first : options.last
        }
        if ascending {
            let next = index + 1
            return next < options.count ? options[next] : nil
        } else {
            let prev = index - 1
            return prev >= 0 ? options[prev] : nil
        }
    }

    private static func clampedBet(_ bet: Int, balance: Int) -> Int {
        let options = GameConfiguration.betOptions
        let affordable = options.filter { $0 <= max(balance, options.first ?? 100) }
        if affordable.contains(bet) {
            return bet
        }
        return affordable.last ?? options.first ?? GameConfiguration.defaultBet
    }

    static func formatCoins(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

enum DailyDayStatus {
    case claimed
    case available
    case locked
}
