import SwiftUI

enum MainTab: Hashable {
    case home
    case achievements
    case profile
}

struct RootView: View {
    @EnvironmentObject private var store: GameStore
    @State private var tab: MainTab = .home
    @State private var showGame = false
    @State private var showSettings = false
    @State private var showLuckyBonus = false
    @State private var showSpinWheel = false
    @State private var showDailyReward = false
    @State private var showMissions = false
    @State private var showSplash = true
    @State private var showComplianceGate = false

    private var showsMainUI: Bool {
        !showSplash && store.hasAcceptedCompliance
    }

    var body: some View {
        ZStack {
            CityBackgroundView(dimOpacity: tab == .home ? 0.25 : 0.45)

            Group {
                switch tab {
                case .home:
                    HomeView(
                        onPlay: { showGame = true },
                        onSettings: { showSettings = true },
                        onDailyReward: { showDailyReward = true },
                        onMissions: { showMissions = true },
                        onLuckyBonus: { showLuckyBonus = true },
                        onSpinWheel: { showSpinWheel = true }
                    )
                case .achievements:
                    AchievementsView()
                case .profile:
                    ProfileView()
                }
            }
            .opacity(showsMainUI ? 1 : 0)

            VStack {
                Spacer()
                BottomTabBar(selected: $tab)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 8)
            }
            .opacity(showsMainUI ? 1 : 0)

            if let toast = store.toast {
                VStack {
                    Text(toast)
                        .font(.headline.bold())
                        .foregroundColor(.black)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(AppTheme.goldGradient)
                        .clipShape(Capsule())
                        .shadow(color: AppTheme.gold.opacity(0.5), radius: 10)
                        .padding(.top, 56)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(20)
            }

            if showComplianceGate && !store.hasAcceptedCompliance {
                ComplianceGateView {
                    store.acceptCompliance()
                    withAnimation(.easeInOut(duration: 0.35)) {
                        showComplianceGate = false
                    }
                }
                .transition(.opacity)
                .zIndex(40)
            }

            if showSplash {
                SplashView {
                    withAnimation(.easeInOut(duration: 0.45)) {
                        showSplash = false
                        if !store.hasAcceptedCompliance {
                            showComplianceGate = true
                        }
                    }
                }
                .transition(.opacity)
                .zIndex(50)
            }
        }
        .animation(.easeInOut(duration: 0.45), value: showSplash)
        .animation(.spring(response: 0.35), value: store.toast)
        .fullScreenCover(isPresented: $showGame) {
            GameView(onClose: { showGame = false })
                .environmentObject(store)
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView(onClose: { showSettings = false })
                .environmentObject(store)
        }
        .fullScreenCover(isPresented: $showLuckyBonus) {
            LuckyBonusView(onClose: { showLuckyBonus = false })
                .environmentObject(store)
        }
        .fullScreenCover(isPresented: $showSpinWheel) {
            SpinWheelView(onClose: { showSpinWheel = false })
                .environmentObject(store)
        }
        .fullScreenCover(isPresented: $showDailyReward) {
            DailyRewardView(onClose: { showDailyReward = false })
                .environmentObject(store)
        }
        .fullScreenCover(isPresented: $showMissions) {
            MissionsView(onClose: { showMissions = false })
                .environmentObject(store)
        }
    }
}

struct BottomTabBar: View {
    @Binding var selected: MainTab

    var body: some View {
        HStack(spacing: 6) {
            tabItem(.home, title: "HOME", system: "house.fill")
            tabItem(.achievements, title: "ACHIEVEMENTS", system: "trophy.fill")
            tabItem(.profile, title: "PROFILE", system: "person.fill")
        }
        .padding(.horizontal, 8)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.ultraThinMaterial)

                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.18, green: 0.08, blue: 0.36).opacity(0.78),
                                Color(red: 0.06, green: 0.03, blue: 0.16).opacity(0.88)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                AppTheme.gold.opacity(0.75),
                                AppTheme.gold.opacity(0.2),
                                Color(red: 0.7, green: 0.4, blue: 1.0).opacity(0.45)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.4
                    )

                // Top sheen
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.14), .clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
            }
            .shadow(color: .black.opacity(0.45), radius: 16, y: 6)
            .shadow(color: AppTheme.gold.opacity(0.15), radius: 10, y: 0)
        }
    }

    private func tabItem(_ tab: MainTab, title: String, system: String) -> some View {
        let isActive = selected == tab

        return Button {
            withAnimation(.spring(response: 0.34, dampingFraction: 0.72)) {
                selected = tab
            }
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    if isActive {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        AppTheme.gold.opacity(0.45),
                                        AppTheme.gold.opacity(0.12)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 56, height: 32)
                            .overlay(
                                Capsule()
                                    .stroke(AppTheme.gold.opacity(0.55), lineWidth: 1)
                            )
                            .shadow(color: AppTheme.gold.opacity(0.55), radius: 10)
                    }

                    Image(systemName: system)
                        .font(.system(size: isActive ? 18 : 16, weight: .bold))
                        .foregroundStyle(
                            isActive
                            ? AnyShapeStyle(AppTheme.goldGradient)
                            : AnyShapeStyle(Color.white.opacity(0.55))
                        )
                        .shadow(color: isActive ? AppTheme.gold.opacity(0.7) : .clear, radius: 6)
                }
                .frame(height: 32)

                Text(title)
                    .font(.system(size: 9, weight: .heavy, design: .rounded))
                    .foregroundStyle(
                        isActive
                        ? AnyShapeStyle(AppTheme.goldGradient)
                        : AnyShapeStyle(Color.white.opacity(0.5))
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
        .buttonStyle(PressableButtonStyle(scale: 0.94))
    }
}
