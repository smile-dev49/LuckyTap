import SwiftUI

struct RootView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            HomeView(path: $path)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .game:
                        GameView()
                    case .dailyReward:
                        DailyRewardView()
                    case .settings:
                        SettingsView()
                    }
                }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(GameViewModel())
}
