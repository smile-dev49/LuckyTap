import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: GameViewModel
    @Binding var path: NavigationPath
    @State private var comingSoonTitle: String?

    var body: some View {
        ZStack {
            // Full-bleed home background asset
            Image("home_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.15),
                            Color.black.opacity(0.35),
                            Color(red: 0.08, green: 0.02, blue: 0.18).opacity(0.75)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                Spacer(minLength: 6)

                Image("lucky_tap_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 280)
                    .shadow(color: GameTheme.neonBlue.opacity(0.55), radius: 12)
                    .shadow(color: .black.opacity(0.45), radius: 6, y: 3)
                    .padding(.horizontal, 24)

                heroSection
                    .padding(.top, 4)

                Spacer(minLength: 10)

                CasinoButton(
                    title: "PLAY",
                    style: .orange,
                    fontSize: 34,
                    horizontalPadding: 20,
                    verticalPadding: 17
                ) {
                    path.append(AppRoute.game)
                }
                .padding(.horizontal, 48)
                .neonGlow(GameTheme.orangeButtonTop, radius: 16)

                featureGrid
                    .padding(.top, 22)
                    .padding(.horizontal, 18)

                Spacer(minLength: 12)

                homeTabBar
            }
        }
        .navigationBarHidden(true)
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

    // MARK: - Top bar

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
                            colors: [GameTheme.goldLight, GameTheme.gold],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.42, green: 0.20, blue: 0.72),
                                        Color(red: 0.18, green: 0.08, blue: 0.40)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(GameTheme.gold.opacity(0.85), lineWidth: 2)
                            )
                    )
                    .shadow(color: GameTheme.gold.opacity(0.4), radius: 8)
            }
            .buttonStyle(ScalePressStyle())
            .accessibilityLabel("Settings")
        }
    }

    // MARK: - Hero (mascot + 555 slot)

    private var heroSection: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Image("home_mascot")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 170, maxHeight: 170)
                .shadow(color: .black.opacity(0.45), radius: 8, y: 4)

            Image("home_slot_555")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200, maxHeight: 150)
                .shadow(color: GameTheme.gold.opacity(0.55), radius: 12)
                .offset(x: -8, y: -4)
        }
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Feature grid

    private var featureGrid: some View {
        HStack(spacing: 12) {
            HomeFeatureButton(
                title: "Daily Reward",
                imageName: "icon_daily_reward"
            ) {
                path.append(AppRoute.dailyReward)
            }

            HomeFeatureButton(
                title: "Missions",
                imageName: "icon_missions"
            ) {
                comingSoonTitle = "Missions"
            }

            HomeFeatureButton(
                title: "Lucky Bonus",
                imageName: "icon_lucky_bonus"
            ) {
                comingSoonTitle = "Lucky Bonus"
            }

            HomeFeatureButton(
                title: "Spin Wheel",
                imageName: "icon_spin_wheel"
            ) {
                comingSoonTitle = "Spin Wheel"
            }
        }
    }

    // MARK: - Bottom tab bar (visual; Home active)

    private var homeTabBar: some View {
        HStack {
            tabItem(icon: "house.fill", title: "HOME", active: true) {}
            tabItem(icon: "trophy.fill", title: "ACHIEVEMENTS", active: false) {
                comingSoonTitle = "Achievements"
            }
            tabItem(icon: "person.fill", title: "PROFILE", active: false) {
                comingSoonTitle = "Profile"
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(
            Rectangle()
                .fill(Color.black.opacity(0.55))
                .overlay(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    GameTheme.neonPurple.opacity(0.35),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 2),
                    alignment: .top
                )
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func tabItem(icon: String, title: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                Text(title)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .tracking(0.4)
            }
            .foregroundStyle(active ? GameTheme.gold : GameTheme.gold.opacity(0.45))
            .shadow(color: active ? GameTheme.gold.opacity(0.6) : .clear, radius: 6)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(ScalePressStyle())
    }
}

// MARK: - Feature button

struct HomeFeatureButton: View {
    let title: String
    let imageName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.32, green: 0.14, blue: 0.58),
                                    Color(red: 0.12, green: 0.05, blue: 0.30)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(GameTheme.goldGradient, lineWidth: 2)
                        )
                        .shadow(color: GameTheme.gold.opacity(0.35), radius: 6)

                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(10)
                }
                .frame(height: 72)
                .frame(maxWidth: .infinity)

                Text(title)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(GameTheme.goldLight)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
        }
        .buttonStyle(ScalePressStyle())
    }
}
