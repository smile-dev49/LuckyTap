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

            VStack {
                Spacer()
                BottomTabBar(selected: $tab)
            }

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
        }
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
        .padding(.top, 10)
        .padding(.bottom, 18)
        .background(
            Rectangle()
                .fill(Color.black.opacity(0.55))
                .overlay(Rectangle().stroke(AppTheme.gold.opacity(0.35), lineWidth: 1))
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func tabButton(_ tab: MainTab, title: String, system: String) -> some View {
        Button {
            selected = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: system)
                    .font(.system(size: 18, weight: .bold))
                Text(title)
                    .font(.system(size: 10, weight: .heavy))
            }
            .foregroundColor(selected == tab ? AppTheme.gold : .white.opacity(0.55))
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
