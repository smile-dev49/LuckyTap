import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: GameStore
    var onClose: () -> Void

    var body: some View {
        ZStack {
            CityBackgroundView(dimOpacity: 0.45)

            VStack(spacing: 0) {
                HStack {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Circle().fill(Color.black.opacity(0.4)))
                            .overlay(Circle().stroke(AppTheme.gold.opacity(0.45), lineWidth: 1.2))
                    }
                    .buttonStyle(PressableButtonStyle())
                    Spacer()
                    Text("SETTINGS")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundStyle(AppTheme.goldGradient)
                    Spacer()
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        Image("BrandLogo")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                            .frame(height: 88)
                            .padding(.top, 8)

                        VStack(spacing: 0) {
                            toggleRow("Sound", system: "speaker.wave.2.fill", isOn: $store.player.soundEnabled)
                            Divider().background(Color.white.opacity(0.12))
                            toggleRow("Haptics", system: "iphone.radiowaves.left.and.right", isOn: $store.player.hapticsEnabled)
                        }
                        .background(panelFill)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .goldBorder(cornerRadius: 18)
                        .onChange(of: store.player.soundEnabled) { _, _ in store.save() }
                        .onChange(of: store.player.hapticsEnabled) { _, _ in store.save() }

                        VStack(alignment: .leading, spacing: 10) {
                            Text("About")
                                .font(.system(size: 16, weight: .heavy, design: .rounded))
                                .foregroundColor(AppTheme.gold)
                            Text("Lucky Tap — 555 Slots")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            Text("Virtual coins only. Local play. SDK-ready later.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.65))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(panelFill)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .goldBorder(cornerRadius: 18)

                        Button(role: .destructive) {
                            store.resetProgress()
                        } label: {
                            Text("Reset Progress")
                                .font(.headline.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: [Color.red.opacity(0.9), Color(red: 0.65, green: 0.08, blue: 0.12)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                        .buttonStyle(PressableButtonStyle())
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 28)
                }
            }
        }
    }

    private var panelFill: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(Color.black.opacity(0.42))
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .opacity(0.55)
            )
    }

    private func toggleRow(_ title: String, system: String, isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn) {
            HStack(spacing: 12) {
                Image(systemName: system)
                    .foregroundStyle(AppTheme.goldGradient)
                    .frame(width: 22)
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .tint(AppTheme.neonGreen)
        .padding(16)
    }
}
