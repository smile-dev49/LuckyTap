import SwiftUI

struct BetControlView: View {
    let bet: Int
    let canDecrease: Bool
    let canIncrease: Bool
    let onDecrease: () -> Void
    let onIncrease: () -> Void

    var body: some View {
        VStack(spacing: 6) {
            Text("BET")
                .font(.system(size: 12, weight: .black, design: .rounded))
                .foregroundStyle(GameTheme.gold)
                .tracking(2)

            HStack(spacing: 8) {
                betStepButton(symbol: "minus", enabled: canDecrease, action: onDecrease)

                Text(GameViewModel.formatCoins(bet))
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .monospacedDigit()
                    .frame(minWidth: 64)
                    .lineLimit(1)
                    .minimumScaleFactor(0.55)

                betStepButton(symbol: "plus", enabled: canIncrease, action: onIncrease)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.5))
                    .overlay(
                        Capsule()
                            .stroke(GameTheme.goldGradient, lineWidth: 1.8)
                    )
            )
        }
    }

    private func betStepButton(symbol: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 13, weight: .black))
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(
                    Circle()
                        .fill(GameTheme.orangeButtonGradient)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.4), lineWidth: 1)
                        )
                        .shadow(color: GameTheme.orangeButtonTop.opacity(0.5), radius: 4)
                )
                .opacity(enabled ? 1 : 0.4)
        }
        .disabled(!enabled)
        .buttonStyle(ScalePressStyle())
    }
}
