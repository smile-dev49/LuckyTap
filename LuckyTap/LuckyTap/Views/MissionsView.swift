import SwiftUI

/// Active missions with progress and claimable coin rewards.
struct MissionsView: View {
    @EnvironmentObject private var store: GameStore
    var onClose: () -> Void

    private var completedCount: Int {
        store.player.missions.filter(\.isComplete).count
    }

    var body: some View {
        ZStack {
            CityBackgroundView(dimOpacity: 0.42)

            VStack(spacing: 0) {
                header

                HStack(spacing: 12) {
                    statPill("Active", "\(store.player.missions.filter { !$0.claimed }.count)")
                    statPill("Done", "\(completedCount)/\(store.player.missions.count)")
                    statPill("Claimable", "\(store.player.missions.filter { $0.isComplete && !$0.claimed }.count)")
                }
                .padding(.horizontal, 18)
                .padding(.top, 10)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        Text("Complete tasks while you play to earn bonus coins.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.65))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ForEach(store.player.missions) { mission in
                            missionRow(mission)
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 14)
                    .padding(.bottom, 36)
                }
            }
        }
    }

    private var header: some View {
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
            Text("MISSIONS")
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundStyle(AppTheme.goldGradient)
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 18)
        .padding(.top, 8)
    }

    private func statPill(_ title: String, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 16, weight: .black, design: .rounded))
                .foregroundColor(AppTheme.gold)
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.38))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(AppTheme.gold.opacity(0.3), lineWidth: 1)
        )
    }

    private func missionRow(_ mission: Mission) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(mission.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text("🪙 \(GameStore.format(mission.reward))")
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundColor(AppTheme.gold)
            }
            ProgressBarView(progress: mission.fraction)
            HStack {
                Text(mission.progressText)
                    .font(.caption.bold())
                    .foregroundColor(.white.opacity(0.65))
                Spacer()
                if mission.claimed {
                    Text("CLAIMED")
                        .font(.caption.bold())
                        .foregroundColor(AppTheme.neonGreen)
                } else if mission.isComplete {
                    Button("CLAIM") {
                        store.claimMission(mission.id)
                    }
                    .font(.caption.bold())
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppTheme.neonGreen)
                    .clipShape(Capsule())
                } else {
                    Text("IN PROGRESS")
                        .font(.caption.bold())
                        .foregroundColor(AppTheme.neonBlue)
                }
            }
        }
        .padding(14)
        .background(Color.black.opacity(0.38))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .goldBorder(cornerRadius: 14, lineWidth: 1)
    }
}
