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
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(GameTheme.gold)
                .tracking(1.5)

            HStack(spacing: 10) {
                betStepButton(symbol: "minus", enabled: canDecrease, action: onDecrease)

                Text(GameViewModel.formatCoins(bet))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .monospacedDigit()
                    .frame(minWidth: 72)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)

                betStepButton(symbol: "plus", enabled: canIncrease, action: onIncrease)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.45))
                    .overlay(
                        Capsule()
                            .stroke(GameTheme.gold.opacity(0.7), lineWidth: 1.5)
                    )
            )
        }
    }

    private func betStepButton(symbol: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 14, weight: .black))
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(
                    Circle()
                        .fill(GameTheme.orangeButtonGradient)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                        )
                )
                .opacity(enabled ? 1 : 0.4)
        }
        .disabled(!enabled)
        .buttonStyle(ScalePressStyle())
    }
}
