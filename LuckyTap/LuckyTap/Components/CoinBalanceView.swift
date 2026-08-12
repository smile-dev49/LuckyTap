import SwiftUI

struct CoinBalanceView: View {
    let balance: Int
    var compact: Bool = false
    var showPlus: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            OptionalAssetImage(name: "coin_icon") {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [GameTheme.goldLight, GameTheme.goldDark],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    Text("$")
                        .font(.system(size: compact ? 11 : 13, weight: .black, design: .rounded))
                        .foregroundStyle(Color(red: 0.55, green: 0.32, blue: 0.02))
                }
            }
            .frame(width: compact ? 24 : 28, height: compact ? 24 : 28)
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
        .padding(.leading, compact ? 10 : 12)
        .padding(.trailing, showPlus ? 8 : (compact ? 10 : 14))
        .padding(.vertical, compact ? 6 : 8)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.50))
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
