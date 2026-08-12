import SwiftUI

struct GameView: View {
    @EnvironmentObject private var store: GameStore
    var onClose: () -> Void

    var body: some View {
        ZStack {
            CityBackgroundView(dimOpacity: 0.4)

            VStack(spacing: 0) {
                header
                    .padding(.horizontal, 16)
                    .padding(.top, 6)

                Spacer(minLength: 10)

                // Main play cluster — kept tight so no empty purple gap
                VStack(spacing: 14) {
                    Text("WIN UP TO \(GameStore.format(store.winUpTo))")
                        .font(.system(size: 13, weight: .black, design: .rounded))
                        .foregroundColor(AppTheme.gold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.black.opacity(0.45))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.red.opacity(0.75), lineWidth: 1.8))

                    SlotMachinePanel(reels: store.displayedReels, spinning: store.isSpinning)
                        .padding(.horizontal, 18)

                    Text(store.statusMessage)
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(Color.black.opacity(0.62))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(AppTheme.gold.opacity(0.25), lineWidth: 1)
                        )
                        .padding(.horizontal, 24)

                    winBox
                        .padding(.horizontal, 22)

                    // Compact pay hints — fills middle smoothly
                    payHintRow
                        .padding(.horizontal, 20)
                }

                Spacer(minLength: 16)

                controlsPanel
                    .padding(.horizontal, 12)
                    .padding(.bottom, 22)
            }
        }
    }

    private var header: some View {
        HStack {
            Button(action: onClose) {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(Color.black.opacity(0.4)))
                    .overlay(Circle().stroke(AppTheme.gold.opacity(0.45), lineWidth: 1.2))
            }
            .buttonStyle(PressableButtonStyle())

            Spacer()

            VStack(spacing: 4) {
                Text("LEVEL \(store.player.level)")
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .foregroundColor(AppTheme.gold)
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: i < starCount ? "star.fill" : "star")
                            .foregroundColor(AppTheme.gold)
                            .font(.system(size: 12))
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.black.opacity(0.35))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(AppTheme.gold.opacity(0.3), lineWidth: 1))

            Spacer()

            CoinBadge(amount: store.player.coins)
        }
    }

    private var starCount: Int {
        min(3, store.player.level / 5 + 1)
    }

    private var winBox: some View {
        HStack(spacing: 8) {
            Text("TOTAL WIN")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.85))
            Spacer()
            Text("🪙")
            Text(GameStore.format(store.lastResult?.payout ?? 0))
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundColor(AppTheme.gold)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.black.opacity(0.45))
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .opacity(0.55)
                )
        )
        .goldBorder(cornerRadius: 16)
    }

    private var payHintRow: some View {
        HStack(spacing: 8) {
            payChip("555", "50×")
            payChip("💎💎💎", "20×")
            payChip("⭐⭐⭐", "15×")
            payChip("PAIR", "1.5×")
        }
    }

    private func payChip(_ title: String, _ mult: String) -> some View {
        VStack(spacing: 3) {
            Text(title)
                .font(.system(size: 11, weight: .heavy))
                .foregroundColor(.white)
            Text(mult)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.gold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.38))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(AppTheme.gold.opacity(0.28), lineWidth: 1)
        )
    }

    private var controlsPanel: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(spacing: 6) {
                Text("BET")
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundColor(.white.opacity(0.7))
                HStack(spacing: 6) {
                    roundControl(system: "minus") { store.decreaseBet() }
                    Text(GameStore.format(store.player.bet))
                        .font(.system(size: 13, weight: .black, design: .rounded))
                        .foregroundColor(AppTheme.gold)
                        .frame(minWidth: 68)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    roundControl(system: "plus") { store.increaseBet() }
                }
            }
            .frame(maxWidth: .infinity)

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
                        .frame(width: 92, height: 92)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.35), lineWidth: 2)
                        )
                        .shadow(color: AppTheme.neonGreen.opacity(0.55), radius: 14)
                    Text(store.waitingToStop ? "STOP" : "TAP")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(PressableButtonStyle(scale: 0.94))
            .frame(maxWidth: .infinity)

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
        .padding(.horizontal, 10)
        .padding(.vertical, 14)
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.08, green: 0.04, blue: 0.18).opacity(0.72))
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .opacity(0.65)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(AppTheme.gold.opacity(0.4), lineWidth: 1.4)
                )
                .shadow(color: .black.opacity(0.35), radius: 12, y: 4)
        }
    }

    private func roundControl(system: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: system)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Color.black.opacity(0.45))
                .clipShape(Circle())
                .overlay(Circle().stroke(AppTheme.gold.opacity(0.5), lineWidth: 1))
        }
        .buttonStyle(PressableButtonStyle())
        .disabled(store.isSpinning)
    }
}

struct SlotMachinePanel: View {
    let reels: [SlotSymbol]
    var spinning: Bool

    var body: some View {
        ZStack(alignment: .trailing) {
            VStack(spacing: 10) {
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
                        SymbolTile(symbol: symbol, size: 82)
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.black.opacity(0.4))
                )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.55, green: 0.35, blue: 0.08), Color(red: 0.35, green: 0.2, blue: 0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(AppTheme.goldGradient, lineWidth: 4)
            )
            .shadow(color: AppTheme.gold.opacity(0.25), radius: 14, y: 4)

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
