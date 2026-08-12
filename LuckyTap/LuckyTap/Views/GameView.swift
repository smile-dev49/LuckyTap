import SwiftUI

struct GameView: View {
    @EnvironmentObject private var store: GameStore
    var onClose: () -> Void

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            // Perspective floor vibe
            VStack {
                Spacer()
                LinearGradient(
                    colors: [AppTheme.neonBlue.opacity(0.15), .clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 220)
            }
            .ignoresSafeArea()

            VStack(spacing: 12) {
                header

                Text("WIN UP TO \(GameStore.format(store.winUpTo))")
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundColor(AppTheme.gold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.4))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.red.opacity(0.7), lineWidth: 2))

                SlotMachinePanel(reels: store.displayedReels, spinning: store.isSpinning)
                    .padding(.horizontal, 20)

                Text(store.statusMessage)
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.65))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 28)

                winBox

                Spacer(minLength: 8)

                controls
                    .padding(.bottom, 28)
            }
            .padding(.top, 8)
        }
    }

    private var header: some View {
        HStack {
            Button(action: onClose) {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.black.opacity(0.35))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            VStack(spacing: 4) {
                Text("LEVEL \(store.player.level)")
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundColor(AppTheme.gold)
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: i < starCount ? "star.fill" : "star")
                            .foregroundColor(AppTheme.gold)
                            .font(.system(size: 12))
                    }
                }
            }

            Spacer()

            CoinBadge(amount: store.player.coins)
        }
        .padding(.horizontal, 16)
    }

    private var starCount: Int {
        min(3, store.player.level / 5 + 1)
    }

    private var winBox: some View {
        HStack(spacing: 8) {
            Text("TOTAL WIN")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.8))
            Spacer()
            Text("🪙")
            Text(GameStore.format(store.lastResult?.payout ?? 0))
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundColor(AppTheme.gold)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(AppTheme.midPurple.opacity(0.55))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .goldBorder(cornerRadius: 14)
        .padding(.horizontal, 28)
    }

    private var controls: some View {
        HStack(alignment: .center, spacing: 12) {
            // Bet
            VStack(spacing: 6) {
                Text("BET")
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundColor(.white.opacity(0.7))
                HStack(spacing: 6) {
                    roundControl(system: "minus") { store.decreaseBet() }
                    Text(GameStore.format(store.player.bet))
                        .font(.system(size: 13, weight: .black, design: .rounded))
                        .foregroundColor(AppTheme.gold)
                        .frame(minWidth: 70)
                    roundControl(system: "plus") { store.increaseBet() }
                }
            }
            .frame(maxWidth: .infinity)

            // TAP
            Button(action: { store.handleTap() }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.neonGreen, Color(red: 0.05, green: 0.55, blue: 0.2)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 96, height: 96)
                        .shadow(color: AppTheme.neonGreen.opacity(0.55), radius: 16)
                    Text(store.waitingToStop ? "STOP" : "TAP")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)

            // Auto
            VStack(spacing: 6) {
                Text("AUTO")
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundColor(.white.opacity(0.7))
                Toggle("", isOn: $store.autoSpin)
                    .labelsHidden()
                    .tint(AppTheme.neonGreen)
                Text(store.autoSpin ? "ON" : "OFF")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(store.autoSpin ? AppTheme.neonGreen : .white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 12)
    }

    private func roundControl(system: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: system)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Color.black.opacity(0.45))
                .clipShape(Circle())
                .overlay(Circle().stroke(AppTheme.gold.opacity(0.5), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .disabled(store.isSpinning)
    }
}

struct SlotMachinePanel: View {
    let reels: [SlotSymbol]
    var spinning: Bool

    var body: some View {
        ZStack(alignment: .trailing) {
            VStack(spacing: 10) {
                // Marquee lights
                HStack(spacing: 6) {
                    ForEach(0..<11, id: \.self) { i in
                        Circle()
                            .fill(i % 2 == 0 ? AppTheme.gold : Color.yellow.opacity(0.55))
                            .frame(width: 10, height: 10)
                            .opacity(spinning ? (i % 2 == 0 ? 1 : 0.4) : 1)
                    }
                }
                .animation(spinning ? .easeInOut(duration: 0.25).repeatForever(autoreverses: true) : .default, value: spinning)

                HStack(spacing: 8) {
                    ForEach(Array(reels.enumerated()), id: \.offset) { _, symbol in
                        SymbolTile(symbol: symbol, size: 78)
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.35))
                )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.55, green: 0.35, blue: 0.08), Color(red: 0.35, green: 0.2, blue: 0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(AppTheme.goldGradient, lineWidth: 4)
            )

            // Lever
            VStack(spacing: 0) {
                Capsule()
                    .fill(AppTheme.goldGradient)
                    .frame(width: 10, height: 56)
                Circle()
                    .fill(Color.red)
                    .frame(width: 28, height: 28)
                    .overlay(Circle().stroke(Color.white.opacity(0.4), lineWidth: 2))
                    .shadow(color: .red.opacity(0.5), radius: 6)
            }
            .offset(x: 18, y: -10)
            .rotationEffect(.degrees(spinning ? 25 : 0), anchor: .top)
            .animation(.easeInOut(duration: 0.2), value: spinning)
        }
        .padding(.trailing, 12)
    }
}
