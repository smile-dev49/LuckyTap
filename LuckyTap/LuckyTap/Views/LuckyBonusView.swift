import SwiftUI

struct LuckyBonusView: View {
    @EnvironmentObject private var store: GameStore
    var onClose: () -> Void
    @State private var result: SpinResult?
    @State private var spinning = false

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 18) {
                HStack {
                    closeButton
                    Spacer()
                    Text("LUCKY BONUS")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(AppTheme.goldGradient)
                    Spacer()
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal, 18)

                Text("Free spins — no bet charged")
                    .font(.subheadline.bold())
                    .foregroundColor(.white.opacity(0.7))

                Text("Spins left: \(store.player.bonusSpinsLeft)")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(AppTheme.neonBlue)

                SlotMachinePanel(reels: store.displayedReels, spinning: spinning)
                    .padding(.horizontal, 24)

                if let result {
                    VStack(spacing: 6) {
                        Text(result.label)
                            .font(.headline.bold())
                            .foregroundColor(.white)
                        Text("+\(GameStore.format(result.payout))")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(AppTheme.gold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.panel)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 28)
                }

                Spacer()

                PrimaryButton(title: spinning ? "SPINNING..." : "BONUS SPIN") {
                    guard !spinning else { return }
                    spinning = true
                    result = nil
                    Task {
                        for _ in 0..<12 {
                            store.displayedReels = SlotEngine.spin()
                            try? await Task.sleep(nanoseconds: 70_000_000)
                        }
                        if let r = store.playBonusSpin() {
                            result = r
                        }
                        spinning = false
                    }
                }
                .padding(.horizontal, 36)
                .disabled(store.player.bonusSpinsLeft <= 0 || spinning)
                .opacity(store.player.bonusSpinsLeft <= 0 ? 0.5 : 1)

                Text("Resets daily")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.45))
                    .padding(.bottom, 28)
            }
        }
    }

    private var closeButton: some View {
        Button(action: onClose) {
            Image(systemName: "xmark")
                .font(.title3.bold())
                .foregroundColor(.white)
                .padding(10)
                .background(Color.black.opacity(0.35))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
