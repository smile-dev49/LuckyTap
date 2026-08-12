import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: GameViewModel
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            VegasBackground()

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 18)
                    .padding(.top, 8)

                Spacer(minLength: 8)

                LuckyTapLogo(size: 1.05)
                    .padding(.bottom, 6)

                // Hero: mascot + 555 machine (SwiftUI only)
                HStack(alignment: .bottom, spacing: 4) {
                    MascotView()
                        .scaleEffect(0.92)
                        .offset(x: -4)

                    SlotMachineView(
                        reels: [5, 5, 5],
                        spinning: [false, false, false],
                        showLever: true
                    )
                    .frame(maxWidth: 210)
                    .scaleEffect(0.92)
                }
                .padding(.horizontal, 12)

                Spacer(minLength: 18)

                CasinoButton(
                    title: "PLAY",
                    style: .orange,
                    fontSize: 34,
                    horizontalPadding: 28,
                    verticalPadding: 18
                ) {
                    path.append(AppRoute.game)
                }
                .padding(.horizontal, 42)
                .neonGlow(GameTheme.orangeButtonTop, radius: 14)

                dailyRewardButton
                    .padding(.top, 28)

                Spacer(minLength: 24)
            }
        }
        .navigationBarHidden(true)
    }

    private var topBar: some View {
        HStack(spacing: 10) {
            CoinBalanceView(balance: viewModel.coinBalance, showPlus: true)

            Spacer()

            Button {
                path.append(AppRoute.settings)
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [GameTheme.goldLight, GameTheme.gold, GameTheme.goldDark],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 46, height: 46)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.35, green: 0.15, blue: 0.55),
                                        Color(red: 0.12, green: 0.05, blue: 0.28)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(
                                Circle()
                                    .stroke(GameTheme.gold.opacity(0.75), lineWidth: 2)
                            )
                    )
                    .shadow(color: GameTheme.gold.opacity(0.45), radius: 8)
            }
            .buttonStyle(ScalePressStyle())
            .accessibilityLabel("Settings")
        }
    }

    private var dailyRewardButton: some View {
        Button {
            path.append(AppRoute.dailyReward)
        } label: {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.42, green: 0.18, blue: 0.72),
                                    Color(red: 0.16, green: 0.06, blue: 0.38)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 78, height: 78)
                        .overlay(
                            Circle()
                                .stroke(GameTheme.goldGradient, lineWidth: 3)
                        )
                        .shadow(color: GameTheme.gold.opacity(0.55), radius: 10)

                    Image(systemName: "gift.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.55, blue: 0.75),
                                    Color(red: 1.0, green: 0.35, blue: 0.45)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .pink.opacity(0.6), radius: 4)
                }

                Text("Daily Reward")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.5), radius: 1, y: 1)
            }
        }
        .buttonStyle(ScalePressStyle())
    }
}
