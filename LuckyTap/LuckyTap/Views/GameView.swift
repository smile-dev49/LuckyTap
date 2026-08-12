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
                    .padding(.top, 16)
                    .padding(.horizontal, 28)

                Spacer(minLength: 12)

                ZStack {
                    SlotMachineView(
                        reels: viewModel.displayedReels,
                        spinning: viewModel.spinningReels,
                        showLever: true
                    )
                    .frame(maxWidth: 340)
                    .padding(.horizontal, 24)

                    if viewModel.showLucky555 {
                        lucky555Overlay
                    }
                }

                Text(viewModel.isSpinning ? "SPINNING..." : "TAP TO SPIN")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(GameTheme.gold)
                    .tracking(1.2)
                    .padding(.top, 10)

                totalWinPanel
                    .padding(.top, 14)
                    .padding(.horizontal, 36)

                Spacer(minLength: 16)

                bottomControls
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
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
                    .frame(width: 42, height: 42)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.35))
                            .overlay(Circle().stroke(GameTheme.gold.opacity(0.55), lineWidth: 1.5))
                    )
            }
            .buttonStyle(ScalePressStyle())
            .accessibilityLabel("Back")

            Spacer()

            CoinBalanceView(balance: viewModel.coinBalance, compact: true)
        }
    }

    private var winBanner: some View {
        Text("WIN UP TO \(GameViewModel.formatCoins(GameConfiguration.maxWinBannerAmount))")
            .font(.system(size: 16, weight: .black, design: .rounded))
            .foregroundStyle(GameTheme.goldGradient)
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.black.opacity(0.4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(GameTheme.goldGradient, lineWidth: 2)
                    )
            )
            .neonGlow(GameTheme.gold, radius: 8)
    }

    private var totalWinPanel: some View {
        VStack(spacing: 4) {
            Text("TOTAL WIN")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(GameTheme.gold.opacity(0.9))
                .tracking(1.5)

            HStack(spacing: 8) {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundStyle(GameTheme.gold)
                    .font(.system(size: 22))

                Text(GameViewModel.formatCoins(animatedWin))
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(GameTheme.goldGradient)
                    .monospacedDigit()
                    .scaleEffect(viewModel.winPulse ? 1.08 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.5), value: viewModel.winPulse)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.black.opacity(0.45))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(GameTheme.gold.opacity(0.75), lineWidth: 2)
                )
        )
    }

    private var bottomControls: some View {
        HStack(alignment: .center, spacing: 12) {
            BetControlView(
                bet: viewModel.selectedBet,
                canDecrease: viewModel.canDecreaseBet && !viewModel.isSpinning,
                canIncrease: viewModel.canIncreaseBet && !viewModel.isSpinning,
                onDecrease: { viewModel.decreaseBet() },
                onIncrease: { viewModel.increaseBet() }
            )

            Spacer(minLength: 4)

            RoundCasinoButton(
                title: "TAP",
                size: 118,
                isEnabled: !viewModel.isSpinning && viewModel.canAffordBet
            ) {
                viewModel.tap()
            }

            Spacer(minLength: 4)

            // Spacer matching bet control width for visual balance (MVP: no Auto)
            Color.clear
                .frame(width: 120, height: 1)
        }
    }

    private var lucky555Overlay: some View {
        VStack(spacing: 8) {
            Text("LUCKY 555!")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [GameTheme.goldLight, .white, GameTheme.gold],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: GameTheme.neonBlue, radius: 10)
                .shadow(color: GameTheme.gold, radius: 16)
                .scaleEffect(viewModel.showLucky555 ? 1.05 : 0.8)
                .opacity(viewModel.showLucky555 ? 1 : 0)
                .animation(.spring(response: 0.45, dampingFraction: 0.55), value: viewModel.showLucky555)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.black.opacity(0.55))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(GameTheme.gold, lineWidth: 2)
                )
        )
        .neonGlow(GameTheme.gold, radius: 18)
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
