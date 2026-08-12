import SwiftUI

struct GameView: View {
    @EnvironmentObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var animatedWin: Int = 0
    @State private var coinBurst = false

    var body: some View {
        ZStack {
            VegasBackground()

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                winBanner
                    .padding(.top, 14)
                    .padding(.horizontal, 24)

                Spacer(minLength: 8)

                ZStack {
                    SlotMachineView(
                        reels: viewModel.displayedReels,
                        spinning: viewModel.spinningReels,
                        showLever: true
                    )
                    .frame(maxWidth: 350)
                    .padding(.horizontal, 20)

                    if viewModel.showLucky555 {
                        lucky555Overlay
                    }
                }

                Text(viewModel.isSpinning ? "SPINNING..." : "TAP TO STOP")
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(GameTheme.neonBlue)
                    .shadow(color: GameTheme.neonBlue.opacity(0.8), radius: 6)
                    .tracking(1.4)
                    .padding(.top, 12)

                totalWinPanel
                    .padding(.top, 12)
                    .padding(.horizontal, 32)

                Spacer(minLength: 12)

                bottomControls
                    .padding(.horizontal, 16)
                    .padding(.bottom, 28)
            }

            if coinBurst {
                CoinBurstView()
                    .allowsHitTesting(false)
                    .transition(.opacity)
            }
        }
        .navigationBarHidden(true)
        .onChange(of: viewModel.totalWin) { _, newValue in
            animateWin(to: newValue)
            if viewModel.lastResult.isWin {
                withAnimation(.easeOut(duration: 0.2)) {
                    coinBurst = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + (viewModel.lastResult.isLucky555 ? 1.6 : 0.9)) {
                    withAnimation {
                        coinBurst = false
                    }
                }
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(GameTheme.gold)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.4))
                            .overlay(Circle().stroke(GameTheme.gold.opacity(0.7), lineWidth: 2))
                    )
            }
            .buttonStyle(ScalePressStyle())
            .accessibilityLabel("Back")

            Spacer()

            // Decorative level chip to match reference chrome (visual only for MVP)
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundStyle(GameTheme.gold)
                    .font(.system(size: 12))
                Text("555")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(GameTheme.gold)
                Image(systemName: "star.fill")
                    .foregroundStyle(GameTheme.gold)
                    .font(.system(size: 12))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.4))
                    .overlay(Capsule().stroke(GameTheme.gold.opacity(0.55), lineWidth: 1.5))
            )

            Spacer()

            CoinBalanceView(balance: viewModel.coinBalance, compact: true)
        }
    }

    private var winBanner: some View {
        Text("WIN UP TO \(GameViewModel.formatCoins(GameConfiguration.maxWinBannerAmount))")
            .font(.system(size: 17, weight: .black, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [GameTheme.goldLight, Color.white, GameTheme.gold],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .shadow(color: GameTheme.gold.opacity(0.7), radius: 4)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.45, green: 0.08, blue: 0.22),
                                Color(red: 0.25, green: 0.05, blue: 0.35)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(GameTheme.goldGradient, lineWidth: 2.5)
                    )
            )
            .neonGlow(GameTheme.gold, radius: 10)
    }

    private var totalWinPanel: some View {
        VStack(spacing: 6) {
            Text("TOTAL WIN")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(GameTheme.gold.opacity(0.95))
                .tracking(2)

            HStack(spacing: 10) {
                GoldCoinIcon(size: 28)

                Text(GameViewModel.formatCoins(animatedWin))
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(GameTheme.goldGradient)
                    .monospacedDigit()
                    .scaleEffect(viewModel.winPulse ? 1.1 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.5), value: viewModel.winPulse)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.black.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(GameTheme.goldGradient, lineWidth: 2.5)
                )
        )
        .shadow(color: GameTheme.gold.opacity(0.35), radius: 10)
    }

    private var bottomControls: some View {
        HStack(alignment: .center, spacing: 8) {
            BetControlView(
                bet: viewModel.selectedBet,
                canDecrease: viewModel.canDecreaseBet && !viewModel.isSpinning,
                canIncrease: viewModel.canIncreaseBet && !viewModel.isSpinning,
                onDecrease: { viewModel.decreaseBet() },
                onIncrease: { viewModel.increaseBet() }
            )
            .frame(width: 128)

            Spacer(minLength: 0)

            RoundCasinoButton(
                title: "TAP",
                size: 126,
                isEnabled: !viewModel.isSpinning && viewModel.canAffordBet
            ) {
                viewModel.tap()
            }

            Spacer(minLength: 0)

            // Visual AUTO OFF chip matching reference layout (disabled for MVP)
            VStack(spacing: 6) {
                Text("AUTO")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(GameTheme.gold.opacity(0.85))
                    .tracking(1)

                Text("OFF")
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(.white.opacity(0.75))
                    .frame(width: 64, height: 34)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.45))
                            .overlay(Capsule().stroke(GameTheme.gold.opacity(0.45), lineWidth: 1.5))
                    )
            }
            .frame(width: 128)
            .opacity(0.85)
            .allowsHitTesting(false)
        }
    }

    private var lucky555Overlay: some View {
        VStack(spacing: 8) {
            Text("LUCKY 555!")
                .font(.system(size: 38, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [GameTheme.goldLight, .white, GameTheme.gold],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: GameTheme.neonBlue, radius: 12)
                .shadow(color: GameTheme.gold, radius: 18)
                .scaleEffect(viewModel.showLucky555 ? 1.08 : 0.8)
                .opacity(viewModel.showLucky555 ? 1 : 0)
                .animation(.spring(response: 0.45, dampingFraction: 0.55), value: viewModel.showLucky555)
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(GameTheme.gold, lineWidth: 3)
                )
        )
        .neonGlow(GameTheme.gold, radius: 20)
    }

    private func animateWin(to value: Int) {
        animatedWin = 0
        guard value > 0 else { return }

        let steps = 18
        let stepValue = max(1, value / steps)
        Task {
            var current = 0
            for _ in 0..<steps {
                current = min(value, current + stepValue)
                await MainActor.run { animatedWin = current }
                try? await Task.sleep(nanoseconds: 30_000_000)
            }
            await MainActor.run { animatedWin = value }
        }
    }
}

struct CoinBurstView: View {
    @State private var animate = false

    private let offsets: [(CGFloat, CGFloat, CGFloat)] = [
        (-90, -120, 12), (20, -160, 14), (110, -100, 11),
        (-130, -40, 15), (0, -90, 13), (140, -50, 12),
        (-70, 10, 10), (60, 20, 16), (100, -20, 11),
        (-40, -140, 13), (30, -70, 12), (-110, -80, 14)
    ]

    var body: some View {
        ZStack {
            ForEach(0..<offsets.count, id: \.self) { i in
                let item = offsets[i]
                Image(systemName: "circle.fill")
                    .font(.system(size: item.2))
                    .foregroundStyle(GameTheme.gold)
                    .offset(x: animate ? item.0 : 0, y: animate ? item.1 : 0)
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: 0.9).delay(Double(i) * 0.02),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }
}
