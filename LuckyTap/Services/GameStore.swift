import Foundation
import SwiftUI
import Combine

@MainActor
final class GameStore: ObservableObject {
    @Published var player: PlayerSnapshot
    @Published var isSpinning = false
    @Published var waitingToStop = false
    @Published var displayedReels: [SlotSymbol] = [.five, .five, .five]
    @Published var lastResult: SpinResult?
    @Published var statusMessage = "TAP TO SPIN"
    @Published var autoSpin = false
    @Published var toast: String?
    @Published var hasAcceptedCompliance: Bool

    private let defaultsKey = "lucky_tap_player_v1"
    private let complianceKey = "lucky_tap_compliance_v1"
    private var spinTask: Task<Void, Never>?
    private var pendingResult: [SlotSymbol]?

    init() {
        hasAcceptedCompliance = UserDefaults.standard.bool(forKey: complianceKey)
        if let data = UserDefaults.standard.data(forKey: defaultsKey),
           let decoded = try? JSONDecoder().decode(PlayerSnapshot.self, from: data) {
            player = decoded
        } else {
            player = .fresh()
        }
        refreshDailyAvailability()
        save()
    }

    var winUpTo: Int {
        Int(Double(player.bet) * PayTable.maxMultiplier)
    }

    var formattedCoins: String {
        Self.format(player.coins)
    }

    var canAffordBet: Bool {
        player.coins >= player.bet
    }

    func acceptCompliance() {
        hasAcceptedCompliance = true
        UserDefaults.standard.set(true, forKey: complianceKey)
    }

    func save() {
        if let data = try? JSONEncoder().encode(player) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }

    func resetProgress() {
        player = .fresh()
        displayedReels = [.five, .five, .five]
        lastResult = nil
        statusMessage = "TAP TO SPIN"
        autoSpin = false
        save()
        showToast("Progress reset")
    }

    func increaseBet() {
        guard !isSpinning else { return }
        player.bet = min(PlayerSnapshot.maxBet, player.bet + PlayerSnapshot.betStep)
        save()
    }

    func decreaseBet() {
        guard !isSpinning else { return }
        player.bet = max(PlayerSnapshot.minBet, player.bet - PlayerSnapshot.betStep)
        save()
    }

    func handleTap() {
        if isSpinning && waitingToStop {
            stopSpin()
        } else if !isSpinning {
            startSpin()
        }
    }

    func startSpin() {
        guard !isSpinning else { return }
        guard canAffordBet else {
            showToast("Not enough coins")
            return
        }

        player.coins -= player.bet
        player.totalSpins += 1
        bumpMission(id: "play10", by: 1)
        addXP(10)
        save()

        isSpinning = true
        waitingToStop = true
        lastResult = nil
        statusMessage = "TAP TO STOP"
        pendingResult = SlotEngine.spin()

        spinTask?.cancel()
        spinTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                self.displayedReels = [
                    SlotEngine.tickSymbol(),
                    SlotEngine.tickSymbol(),
                    SlotEngine.tickSymbol()
                ]
                try? await Task.sleep(nanoseconds: 80_000_000)
            }
        }
    
        Task { [weak self] in
            try? await Task.sleep(nanoseconds: 4_000_000_000)
            guard let self, self.isSpinning, self.waitingToStop else { return }
            self.stopSpin()
        }
    }

    func stopSpin() {
        guard isSpinning, waitingToStop else { return }
        waitingToStop = false
        spinTask?.cancel()
        spinTask = nil

        let finalReels = pendingResult ?? SlotEngine.spin()
        pendingResult = nil

        Task { [weak self] in
            guard let self else { return }
            for i in 0..<3 {
                try? await Task.sleep(nanoseconds: 220_000_000)
                var next = self.displayedReels
                next[i] = finalReels[i]
                self.displayedReels = next
            }

            let result = PayTable.evaluate(reels: finalReels, bet: self.player.bet)
            self.apply(result: result)
            self.isSpinning = false
            self.statusMessage = result.isWin ? result.label : "TAP TO SPIN"

            if self.autoSpin {
                try? await Task.sleep(nanoseconds: 900_000_000)
                if self.autoSpin && !self.isSpinning {
                    self.startSpin()
                }
            }
        }
    }

    private func apply(result: SpinResult) {
        lastResult = result
        if result.payout > 0 {
            player.coins += result.payout
            player.totalWins += 1
            player.bestWin = max(player.bestWin, result.payout)
            bumpMission(id: "win3", by: 1)
            bumpMission(id: "collect50k", by: result.payout)
            addXP(result.isJackpot ? 80 : 25)
        }

        if result.isJackpot {
            player.tripleFiveCount += 1
            bumpMission(id: "triple5", by: 1)
        }

        for symbol in result.reels {
            if let key = symbol.collectionKey,
               let idx = player.collections.firstIndex(where: { $0.id == key }) {
                player.collections[idx].count += 1
            }
        }

        save()
    }

    func refreshDailyAvailability() {
        let today = Self.todayString()
        if player.lastClaimDate != today {
            if let last = player.lastClaimDate, last != today {
            }
        }
        if player.lastBonusClaimDate != today {
            player.bonusSpinsLeft = max(player.bonusSpinsLeft, 3)
        }
        if player.lastWheelClaimDate != today {
            player.wheelSpinsLeft = max(player.wheelSpinsLeft, 1)
        }
    }

    var canClaimDaily: Bool {
        let today = Self.todayString()
        guard player.lastClaimDate != today else { return false }
        let dayIndex = min(max(player.dailyStreakDay, 1), 7) - 1
        return !player.dailyRewards[dayIndex].claimed || player.dailyStreakDay <= 7
    }

    func claimDailyReward() {
        let today = Self.todayString()
        guard player.lastClaimDate != today else {
            showToast("Already claimed today")
            return
        }

        let index = min(max(player.dailyStreakDay, 1), 7) - 1
        let reward = player.dailyRewards[index].reward
        player.coins += reward
        player.dailyRewards[index].claimed = true
        player.lastClaimDate = today

        if player.dailyStreakDay < 7 {
            player.dailyStreakDay += 1
        } else {
            player.dailyStreakDay = 1
            player.dailyRewards = (1...7).map { day in
                DailyRewardDay(day: day, reward: day * 15_000, claimed: false)
            }
        }
        save()
        showToast("+\(Self.format(reward)) coins!")
    }

    func claimMission(_ id: String) {
        guard let idx = player.missions.firstIndex(where: { $0.id == id }) else { return }
        var mission = player.missions[idx]
        guard mission.isComplete, !mission.claimed else { return }
        player.coins += mission.reward
        mission.claimed = true
        player.missions[idx] = mission
        save()
        showToast("Mission reward +\(Self.format(mission.reward))")
    }

    private func bumpMission(id: String, by amount: Int) {
        guard let idx = player.missions.firstIndex(where: { $0.id == id }) else { return }
        if player.missions[idx].claimed { return }
        player.missions[idx].progress = min(player.missions[idx].target, player.missions[idx].progress + amount)
    }

    func playBonusSpin() -> SpinResult? {
        refreshDailyAvailability()
        guard player.bonusSpinsLeft > 0 else {
            showToast("No bonus spins left")
            return nil
        }
        player.bonusSpinsLeft -= 1
        player.lastBonusClaimDate = Self.todayString()
        let reels = SlotEngine.spin()
        displayedReels = reels
        let result = PayTable.evaluate(reels: reels, bet: 50_000)
        if result.payout > 0 {
            player.coins += result.payout
            player.bestWin = max(player.bestWin, result.payout)
        }
        save()
        return result
    }

    func spinWheel() -> Int? {
        refreshDailyAvailability()
        guard player.wheelSpinsLeft > 0 else {
            showToast("Come back tomorrow")
            return nil
        }
        player.wheelSpinsLeft -= 1
        player.lastWheelClaimDate = Self.todayString()
        let prizes = [5_000, 10_000, 25_000, 50_000, 100_000, 15_000, 8_000, 30_000]
        let prize = prizes.randomElement() ?? 10_000
        player.coins += prize
        save()
        return prize
    }

    private func addXP(_ amount: Int) {
        player.xp += amount
        while player.xp >= player.xpToNext {
            player.xp -= player.xpToNext
            player.level += 1
            player.xpToNext = 500 + (player.level - 1) * 100
            if player.level >= 10 { player.vipTitle = "VIP Pro" }
            if player.level >= 20 { player.vipTitle = "VIP Elite" }
            showToast("Level Up! Lv.\(player.level)")
        }
    }

    func showToast(_ text: String) {
        toast = text
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            if toast == text { toast = nil }
        }
    }

    static func format(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    static func todayString() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
