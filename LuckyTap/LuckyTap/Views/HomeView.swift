import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: GameViewModel
    @Binding var path: NavigationPath
    @State private var comingSoonTitle: String?
    @State private var appearReady = false

    var body: some View {
        ZStack {
            VegasBackground()

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 18)
                    .padding(.top, 6)

                Spacer(minLength: 8)

                Image("lucky_tap_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 260)
                    .shadow(color: GameTheme.neonBlue.opacity(0.45), radius: 10)
                    .shadow(color: .black.opacity(0.35), radius: 4, y: 2)
                    .scaleEffect(appearReady ? 1 : 0.92)
                    .opacity(appearReady ? 1 : 0)

                heroSection
                    .padding(.top, 8)
                    .opacity(appearReady ? 1 : 0)
                    .offset(y: appearReady ? 0 : 12)

                Spacer(minLength: 16)

                CasinoButton(
                    title: "PLAY",
                    style: .orange,
                    fontSize: 32,
                    horizontalPadding: 24,
                    verticalPadding: 16
                ) {
                    path.append(AppRoute.game)
                }
                .padding(.horizontal, 52)
                .neonGlow(GameTheme.orangeButtonTop, radius: 14)
                .scaleEffect(appearReady ? 1 : 0.96)

                featureGrid
                    .padding(.top, 24)
                    .padding(.horizontal, 20)

                Spacer(minLength: 16)

                homeTabBar
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                appearReady = true
            }
        }
        .alert(
            comingSoonTitle.map { "\($0) Coming Soon" } ?? "Coming Soon",
            isPresented: Binding(
                get: { comingSoonTitle != nil },
                set: { if !$0 { comingSoonTitle = nil } }
            )
        ) {
            Button("OK", role: .cancel) { comingSoonTitle = nil }
        } message: {
            Text("This feature will be available in a later update.")
        }
    }

    // MARK: - Top

    private var topBar: some View {
        HStack(spacing: 12) {
            CoinBalanceView(balance: viewModel.coinBalance, showPlus: true)

            Spacer()

            Button {
                path.append(AppRoute.settings)
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(GameTheme.goldGradient)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.40, green: 0.18, blue: 0.70),
                                        Color(red: 0.16, green: 0.06, blue: 0.36)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(Circle().stroke(GameTheme.gold.opacity(0.8), lineWidth: 2))
                    )
                    .shadow(color: GameTheme.gold.opacity(0.35), radius: 8)
            }
            .buttonStyle(ScalePressStyle())
            .accessibilityLabel("Settings")
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        HStack(alignment: .bottom, spacing: 4) {
            Image("home_mascot")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 168)
                .shadow(color: .black.opacity(0.4), radius: 8, y: 4)
                .frame(maxWidth: .infinity)

            Image("home_slot_555")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 148)
                .shadow(color: GameTheme.gold.opacity(0.5), radius: 12)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 12)
    }

    // MARK: - Features (2x2 feel via equal row)

    private var featureGrid: some View {
        HStack(spacing: 14) {
            HomeFeatureButton(title: "Daily Reward", systemIcon: "gift.fill", iconColors: [.pink, .orange]) {
                path.append(AppRoute.dailyReward)
            }
            HomeFeatureButton(title: "Missions", systemIcon: "trophy.fill", iconColors: [GameTheme.goldLight, GameTheme.goldDark]) {
                comingSoonTitle = "Missions"
            }
            HomeFeatureButton(title: "Lucky Bonus", systemIcon: "rectangle.split.3x1.fill", iconColors: [.red, .orange]) {
                comingSoonTitle = "Lucky Bonus"
            }
            HomeFeatureButton(title: "Spin Wheel", systemIcon: "target", iconColors: [GameTheme.neonBlue, GameTheme.neonPink]) {
                comingSoonTitle = "Spin Wheel"
            }
        }
    }

    // MARK: - Tab bar

    private var homeTabBar: some View {
        HStack(spacing: 0) {
            tabItem(icon: "house.fill", title: "HOME", active: true) {}
            tabItem(icon: "trophy.fill", title: "ACHIEVEMENTS", active: false) {
                comingSoonTitle = "Achievements"
            }
            tabItem(icon: "person.fill", title: "PROFILE", active: false) {
                comingSoonTitle = "Profile"
            }
        }
        .padding(.top, 14)
        .padding(.bottom, 8)
        .background(
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 18, topTrailing: 18), style: .continuous)
                .fill(Color.black.opacity(0.58))
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(GameTheme.gold.opacity(0.25))
                        .frame(height: 1)
                }
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func tabItem(icon: String, title: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                Text(title)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .tracking(0.5)
            }
            .foregroundStyle(active ? GameTheme.gold : Color.white.opacity(0.35))
            .shadow(color: active ? GameTheme.gold.opacity(0.55) : .clear, radius: 8)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(ScalePressStyle())
    }
}

struct HomeFeatureButton: View {
    let title: String
    let systemIcon: String
    var iconColors: [Color] = [GameTheme.goldLight, GameTheme.gold]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.30, green: 0.14, blue: 0.55),
                                    Color(red: 0.12, green: 0.05, blue: 0.28)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(GameTheme.gold.opacity(0.75), lineWidth: 1.8)
                        )
                        .shadow(color: GameTheme.gold.opacity(0.22), radius: 6, y: 2)

                    Image(systemName: systemIcon)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(colors: iconColors, startPoint: .top, endPoint: .bottom)
                        )
                        .shadow(color: iconColors.first?.opacity(0.5) ?? .clear, radius: 4)
                }
                .frame(height: 70)
                .frame(maxWidth: .infinity)

                Text(title)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(GameTheme.goldLight)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .buttonStyle(ScalePressStyle())
    }
}
