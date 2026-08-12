import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: GameStore
    var onClose: () -> Void
    @State private var showPrivacy = false
    @State private var showTerms = false
    @State private var confirmReset = false

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
                            Text("\(AppLegal.appName) — Entertainment Slots")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            Text(AppLegal.shortDisclaimer)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                                .fixedSize(horizontal: false, vertical: true)
                            Text(AppLegal.ageNotice)
                                .font(.caption.weight(.semibold))
                                .foregroundColor(AppTheme.gold.opacity(0.9))
                                .fixedSize(horizontal: false, vertical: true)
                            Text("Version 1.0")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.45))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(panelFill)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .goldBorder(cornerRadius: 18)

                        VStack(spacing: 0) {
                            legalButton("Privacy Notice", system: "hand.raised.fill") { showPrivacy = true }
                            Divider().background(Color.white.opacity(0.12))
                            legalButton("Terms of Use", system: "doc.text.fill") { showTerms = true }
                            Divider().background(Color.white.opacity(0.12))
                            if let url = AppLegal.privacyPolicyURL {
                                Link(destination: url) {
                                    legalLabel("Online Privacy Policy", system: "safari.fill")
                                }
                            }
                            Divider().background(Color.white.opacity(0.12))
                            if let mail = URL(string: "mailto:\(AppLegal.supportEmail)") {
                                Link(destination: mail) {
                                    legalLabel("Contact Support", system: "envelope.fill")
                                }
                            }
                        }
                        .background(panelFill)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .goldBorder(cornerRadius: 18)

                        Button {
                            confirmReset = true
                        } label: {
                            Text("Reset Local Progress")
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
                        }
                        .buttonStyle(PressableButtonStyle())

                        Text("Progress is stored only on this device. Reset permanently clears virtual coins and stats.")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.45))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 28)
                }
            }
        }
        .sheet(isPresented: $showPrivacy) {
            legalSheet(title: "Privacy Notice", bodyText: AppLegal.privacySummary)
        }
        .sheet(isPresented: $showTerms) {
            legalSheet(title: "Terms of Use", bodyText: AppLegal.termsSummary)
        }
        .alert("Reset Local Progress?", isPresented: $confirmReset) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                store.resetProgress()
                store.showToast("Local progress reset")
            }
        } message: {
            Text("This deletes virtual coins, missions, and stats saved on this device. It cannot be undone.")
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

    private func legalButton(_ title: String, system: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            legalLabel(title, system: system)
        }
        .buttonStyle(.plain)
    }

    private func legalLabel(_ title: String, system: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: system)
                .foregroundStyle(AppTheme.goldGradient)
                .frame(width: 22)
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundColor(.white.opacity(0.35))
        }
        .padding(16)
    }

    private func legalSheet(title: String, bodyText: String) -> some View {
        NavigationStack {
            ScrollView {
                Text(bodyText)
                    .font(.body)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        showPrivacy = false
                        showTerms = false
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
