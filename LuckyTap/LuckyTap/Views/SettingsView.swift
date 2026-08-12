import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showResetConfirmation = false

    var body: some View {
        ZStack {
            VegasBackground()

            VStack(spacing: 20) {
                header

                LuckyTapLogo(size: 0.62)
                    .padding(.vertical, 4)

                VStack(spacing: 14) {
                    settingsToggleRow(
                        title: "Sound",
                        icon: "speaker.wave.2.fill",
                        isOn: Binding(
                            get: { viewModel.soundEnabled },
                            set: { viewModel.setSoundEnabled($0) }
                        )
                    )

                    settingsToggleRow(
                        title: "Vibration",
                        icon: "iphone.radiowaves.left.and.right",
                        isOn: Binding(
                            get: { viewModel.vibrationEnabled },
                            set: { viewModel.setVibrationEnabled($0) }
                        )
                    )
                }
                .padding(.horizontal, 20)

                VStack(spacing: 8) {
                    Text("Best Win")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                    HStack(spacing: 8) {
                        GoldCoinIcon(size: 24)
                        Text(GameViewModel.formatCoins(viewModel.bestWin))
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundStyle(GameTheme.goldGradient)
                    }
                }
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.45))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(GameTheme.gold.opacity(0.55), lineWidth: 1.8)
                        )
                )
                .padding(.horizontal, 20)

                Spacer()

                CasinoButton(title: "Reset Game", style: .goldOutline, fontSize: 20, verticalPadding: 14) {
                    showResetConfirmation = true
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 32)
            }
            .padding(.top, 8)
        }
        .navigationBarHidden(true)
        .alert(
            "Are you sure you want to reset your Lucky Tap progress?",
            isPresented: $showResetConfirmation
        ) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                viewModel.resetGame()
            }
        } message: {
            Text("Coins, daily reward streak, and selected bet will be restored to defaults.")
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

            Text("SETTINGS")
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: GameTheme.gold.opacity(0.35), radius: 3)

            Spacer()

            Color.clear.frame(width: 42, height: 42)
        }
        .padding(.horizontal, 16)
    }

    private func settingsToggleRow(title: String, icon: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(GameTheme.gold)
                .frame(width: 28)

            Text(title)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Spacer()

            Text(isOn.wrappedValue ? "ON" : "OFF")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(isOn.wrappedValue ? GameTheme.greenButtonTop : .white.opacity(0.5))
                .frame(width: 36)

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(GameTheme.greenButtonBottom)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.black.opacity(0.45))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(GameTheme.gold.opacity(0.5), lineWidth: 1.5)
                )
        )
    }
}
