import SwiftUI

struct CoinBalanceView: View {
    let balance: Int
    var compact: Bool = false
    var showPlus: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            GoldCoinIcon(size: compact ? 24 : 28)

            Text(GameViewModel.formatCoins(balance))
                .font(.system(size: compact ? 15 : 17, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            if showPlus {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [GameTheme.greenButtonTop, GameTheme.greenButtonBottom],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: GameTheme.greenButtonTop.opacity(0.55), radius: 4)
            }
        }
        .padding(.leading, compact ? 10 : 12)
        .padding(.trailing, showPlus ? 8 : (compact ? 10 : 14))
        .padding(.vertical, compact ? 6 : 8)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.5))
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: [GameTheme.goldLight.opacity(0.85), GameTheme.gold.opacity(0.5)],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1.6
                        )
                )
        )
        .accessibilityLabel("Coin balance \(GameViewModel.formatCoins(balance))")
    }
}
