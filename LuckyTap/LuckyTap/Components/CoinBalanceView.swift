import SwiftUI

struct CoinBalanceView: View {
    let balance: Int
    var compact: Bool = false
    var showPlus: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            Image("coin_icon")
                .resizable()
                .scaledToFit()
                .frame(width: compact ? 26 : 30, height: compact ? 26 : 30)
                .shadow(color: GameTheme.gold.opacity(0.7), radius: 4)

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
                    .shadow(color: GameTheme.greenButtonTop.opacity(0.6), radius: 4)
            }
        }
        .padding(.leading, compact ? 8 : 10)
        .padding(.trailing, showPlus ? 8 : (compact ? 10 : 14))
        .padding(.vertical, compact ? 5 : 7)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.55))
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: [GameTheme.goldLight.opacity(0.9), GameTheme.gold.opacity(0.55)],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1.8
                        )
                )
        )
        .accessibilityLabel("Coin balance \(GameViewModel.formatCoins(balance))")
    }
}
