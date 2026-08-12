import SwiftUI

struct DailyRewardView: View {
    @EnvironmentObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var claimMessage: String?

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ZStack {
            VegasBackground()

            VStack(spacing: 14) {
                header

                // Tab chrome matching reference (Daily active; Missions visual-only)
                HStack(spacing: 0) {
                    tabChip(title: "DAILY REWARD", active: true)
                    tabChip(title: "MISSIONS", active: false)
                }
                .padding(4)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.4))
                        .overlay(Capsule().stroke(GameTheme.gold.opacity(0.35), lineWidth: 1))
                )
                .padding(.horizontal, 20)

                Text("Daily Login Streak")
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: GameTheme.neonBlue.opacity(0.5), radius: 4)

                Text("Come back every day for bigger rewards!")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.72))

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(0..<viewModel.dailyRewards.count, id: \.self) { index in
                        dayCard(dayIndex: index)
                            .gridCellColumns(index == 6 ? 2 : 1)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.top, 4)

                if let claimMessage {
                    Text(claimMessage)
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundStyle(GameTheme.gold)
                        .transition(.scale.combined(with: .opacity))
                }

                CasinoButton(
                    title: viewModel.canClaimDailyReward ? "CLAIM" : "CLAIMED",
                    style: .green,
                    isEnabled: viewModel.canClaimDailyReward,
                    fontSize: 28,
                    verticalPadding: 16
                ) {
                    let amount = viewModel.claimDailyReward()
                    if amount > 0 {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            claimMessage = "+\(GameViewModel.formatCoins(amount)) coins!"
                        }
                    }
                }
                .padding(.horizontal, 36)
                .padding(.top, 8)
                .neonGlow(GameTheme.greenButtonTop, radius: 12)

                Spacer(minLength: 8)
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
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.pink, Color.orange],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                Text("REWARDS")
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: GameTheme.gold.opacity(0.4), radius: 3)
            }

            Spacer()

            CoinBalanceView(balance: viewModel.coinBalance, compact: true)
        }
        .padding(.horizontal, 16)
    }

    private func tabChip(title: String, active: Bool) -> some View {
        Text(title)
            .font(.system(size: 12, weight: .black, design: .rounded))
            .foregroundStyle(active ? .white : .white.opacity(0.45))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(
                        active
                        ? LinearGradient(
                            colors: [
                                Color(red: 0.55, green: 0.25, blue: 0.85),
                                Color(red: 0.30, green: 0.10, blue: 0.55)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                          )
                        : LinearGradient(colors: [Color.clear, Color.clear], startPoint: .top, endPoint: .bottom)
                    )
            )
    }

    private func dayCard(dayIndex: Int) -> some View {
        let status = viewModel.dayStatus(for: dayIndex)
        let reward = viewModel.dailyRewards[dayIndex]

        return VStack(spacing: 6) {
            Text("Day \(dayIndex + 1)")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(GameTheme.gold)

            ZStack {
                GoldCoinIcon(size: 34)

                switch status {
                case .claimed:
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.green)
                        .offset(x: 16, y: 14)
                        .shadow(color: .green.opacity(0.6), radius: 3)
                case .locked:
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white.opacity(0.9))
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
        .frame(height: 104)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    status == .available
                    ? LinearGradient(
                        colors: [
                            Color(red: 0.38, green: 0.18, blue: 0.62),
                            Color(red: 0.16, green: 0.06, blue: 0.34)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                      )
                    : LinearGradient(
                        colors: [Color.black.opacity(0.45), Color.black.opacity(0.35)],
                        startPoint: .top,
                        endPoint: .bottom
                      )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(
                            status == .available ? GameTheme.gold : GameTheme.gold.opacity(0.35),
                            lineWidth: status == .available ? 3 : 1.5
                        )
                )
        )
        .shadow(color: status == .available ? GameTheme.gold.opacity(0.6) : .clear, radius: 10)
        .opacity(status == .locked ? 0.7 : 1)
    }
}
