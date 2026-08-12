import SwiftUI

struct CoinBalanceView: View {
    let balance: Int
    var compact: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [GameTheme.goldLight, GameTheme.goldDark],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: compact ? 22 : 26, height: compact ? 22 : 26)
                    .shadow(color: GameTheme.gold.opacity(0.7), radius: 4)

                Text("$")
                    .font(.system(size: compact ? 11 : 13, weight: .black, design: .rounded))
                    .foregroundStyle(Color(red: 0.55, green: 0.32, blue: 0.02))
            }

            Text(GameViewModel.formatCoins(balance))
                .font(.system(size: compact ? 15 : 17, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(.horizontal, compact ? 10 : 14)
        .padding(.vertical, compact ? 6 : 8)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.45))
                .overlay(
                    Capsule()
                        .stroke(GameTheme.gold.opacity(0.65), lineWidth: 1.5)
                )
        )
        .accessibilityLabel("Coin balance \(GameViewModel.formatCoins(balance))")
    }
}
