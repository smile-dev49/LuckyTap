import SwiftUI

enum MainTab: Hashable {
    case home
    case rewards
    case profile
}

struct RootView: View {
    @EnvironmentObject private var store: GameStore
    @State private var tab: MainTab = .home
    @State private var showGame = false
    @State private var showSettings = false
    @State private var showLuckyBonus = false
    @State private var showSpinWheel = false
    @State private var rewardsFocusMissions = false
    @State private var showSplash = true

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            Group {
                switch tab {
                case .home:
                    HomeView(
                        onPlay: { showGame = true },
                        onSettings: { showSettings = true },
                        onDailyReward: {
                            rewardsFocusMissions = false
                            tab = .rewards
                        },
                        onMissions: {
                            rewardsFocusMissions = true
                            tab = .rewards
                        },
                        onLuckyBonus: { showLuckyBonus = true },
                        onSpinWheel: { showSpinWheel = true }
                    )
                case .rewards:
                    RewardsView(startOnMissions: rewardsFocusMissions)
                case .profile:
                    ProfileView()
                }
            }
            .opacity(showSplash ? 0 : 1)

            VStack {
                Spacer()
                BottomTabBar(selected: $tab)
            }
            .opacity(showSplash ? 0 : 1)

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

            if showSplash {
                SplashView()
                    .transition(.opacity)
                    .zIndex(50)
            }
        }
        .animation(.easeInOut(duration: 0.45), value: showSplash)
        .animation(.spring(response: 0.35), value: store.toast)
        .task {
            // Splash duration: ~2.2s (within 1–3s)
            try? await Task.sleep(nanoseconds: 2_200_000_000)
            withAnimation(.easeInOut(duration: 0.45)) {
                showSplash = false
            }
        }
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
    }
}

struct BottomTabBar: View {
    @Binding var selected: MainTab

    var body: some View {
        HStack(spacing: 0) {
            tabButton(.home, title: "HOME", system: "house.fill")
            tabButton(.rewards, title: "ACHIEVEMENTS", system: "trophy.fill")
            tabButton(.profile, title: "PROFILE", system: "person.fill")
        }
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(
                    Rectangle()
                        .fill(Color.black.opacity(0.45))
                )
                .overlay(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.gold.opacity(0.45), AppTheme.gold.opacity(0.08)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 1),
                    alignment: .top
                )
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func tabButton(_ tab: MainTab, title: String, system: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.32, dampingFraction: 0.75)) {
                selected = tab
            }
        } label: {
            VStack(spacing: 5) {
                Image(systemName: system)
                    .font(.system(size: 18, weight: .bold))
                    .scaleEffect(selected == tab ? 1.08 : 1.0)
                Text(title)
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
            }
            .foregroundColor(selected == tab ? AppTheme.gold : .white.opacity(0.45))
            .shadow(color: selected == tab ? AppTheme.gold.opacity(0.45) : .clear, radius: 6)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PressableButtonStyle(scale: 0.92))
    }
}
