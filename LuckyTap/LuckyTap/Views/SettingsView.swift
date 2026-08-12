import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: GameStore
    var onClose: () -> Void

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.35))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    Text("SETTINGS")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundStyle(AppTheme.goldGradient)
                    Spacer()
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal, 18)

                VStack(spacing: 0) {
                    toggleRow("Sound", isOn: $store.player.soundEnabled)
                    Divider().background(Color.white.opacity(0.15))
                    toggleRow("Haptics", isOn: $store.player.hapticsEnabled)
                }
                .background(AppTheme.panel)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .goldBorder(cornerRadius: 16)
                .padding(.horizontal, 18)
                .onChange(of: store.player.soundEnabled) { _, _ in store.save() }
                .onChange(of: store.player.hapticsEnabled) { _, _ in store.save() }

                VStack(alignment: .leading, spacing: 8) {
                    Text("About")
                        .font(.headline.bold())
                        .foregroundColor(.white.opacity(0.8))
                    Text("Lucky Tap — 555 Slots\nVirtual coins only. Local play. SDK-ready later.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(AppTheme.panel)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 18)

                Spacer()

                Button(role: .destructive) {
                    store.resetProgress()
                } label: {
                    Text("Reset Progress")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.75))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 30)
            }
        }
    }

    private func toggleRow(_ title: String, isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .tint(AppTheme.neonGreen)
        .padding(16)
    }
}
