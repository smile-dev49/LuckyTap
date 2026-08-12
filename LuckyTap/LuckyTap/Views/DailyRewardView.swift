import SwiftUI

struct DailyRewardView: View {
    @EnvironmentObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var claimMessage: String?

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ZStack {
            VegasBackground()

            VStack(spacing: 16) {
                header

                Text("Daily Login Streak")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Come back every day for bigger rewards!")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(0..<viewModel.dailyRewards.count, id: \.self) { index in
                        dayCard(dayIndex: index)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                if let claimMessage {
                    Text(claimMessage)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(GameTheme.gold)
                        .transition(.scale.combined(with: .opacity))
                }

                CasinoButton(
                    title: viewModel.canClaimDailyReward ? "CLAIM" : "CLAIMED",
                    style: .green,
                    isEnabled: viewModel.canClaimDailyReward,
                    fontSize: 26,
                    verticalPadding: 16
                ) {
                    let amount = viewModel.claimDailyReward()
                    if amount > 0 {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            claimMessage = "+\(GameViewModel.formatCoins(amount)) coins!"
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 12)

                Spacer()
            }
            .padding(.top, 8)
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.refreshDailyRewardAvailability()
        }
    }

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(GameTheme.gold)
                    .frame(width: 42, height: 42)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.35))
                            .overlay(Circle().stroke(GameTheme.gold.opacity(0.55), lineWidth: 1.5))
                    )
            }
            .buttonStyle(ScalePressStyle())

            Spacer()

            HStack(spacing: 8) {
                Image(systemName: "gift.fill")
                    .foregroundStyle(GameTheme.gold)
                Text("REWARDS")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }

            Spacer()

            CoinBalanceView(balance: viewModel.coinBalance, compact: true)
        }
        .padding(.horizontal, 16)
    }

    private func dayCard(dayIndex: Int) -> some View {
        let status = viewModel.dayStatus(for: dayIndex)
        let reward = viewModel.dailyRewards[dayIndex]

        return VStack(spacing: 6) {
            Text("Day \(dayIndex + 1)")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(GameTheme.gold)

            ZStack {
                Image(systemName: "bitcoinsign.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(GameTheme.goldGradient)

                switch status {
                case .claimed:
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.green)
                        .offset(x: 16, y: 14)
                case .locked:
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white.opacity(0.85))
                        .offset(x: 16, y: 14)
                case .available:
                    EmptyView()
                }
            }

            Text(GameViewModel.formatCoins(reward))
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    status == .available
                    ? Color(red: 0.28, green: 0.14, blue: 0.48).opacity(0.95)
                    : Color.black.opacity(0.4)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(
                            status == .available ? GameTheme.gold : GameTheme.gold.opacity(0.35),
                            lineWidth: status == .available ? 3 : 1.5
                        )
                )
        )
        .shadow(color: status == .available ? GameTheme.gold.opacity(0.55) : .clear, radius: 8)
        .opacity(status == .locked ? 0.65 : 1)
    }
}
