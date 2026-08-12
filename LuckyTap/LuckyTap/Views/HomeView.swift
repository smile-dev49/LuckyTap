import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: GameViewModel
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            VegasBackground()

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                Spacer(minLength: 12)

                LuckyTapLogo(size: 1.05)
                    .padding(.bottom, 8)

                // Mini 555 machine preview
                SlotMachineView(
                    reels: [5, 5, 5],
                    spinning: [false, false, false],
                    showLever: true
                )
                .frame(maxWidth: 320)
                .padding(.horizontal, 28)

                Spacer(minLength: 20)

                CasinoButton(title: "PLAY", style: .orange, fontSize: 32, verticalPadding: 18) {
                    path.append(AppRoute.game)
                }
                .padding(.horizontal, 36)

                Button {
                    path.append(AppRoute.dailyReward)
                } label: {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.28, green: 0.12, blue: 0.48),
                                            Color(red: 0.12, green: 0.05, blue: 0.28)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 72, height: 72)
                                .overlay(
                                    Circle()
                                        .stroke(GameTheme.goldGradient, lineWidth: 2.5)
                                )
                                .shadow(color: GameTheme.gold.opacity(0.45), radius: 8)

                            Image(systemName: "gift.fill")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [GameTheme.goldLight, GameTheme.orangeButtonBottom],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        }

                        Text("Daily Reward")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }
                .buttonStyle(ScalePressStyle())
                .padding(.top, 28)

                Spacer(minLength: 24)
            }
        }
        .navigationBarHidden(true)
    }

    private var topBar: some View {
        HStack {
            CoinBalanceView(balance: viewModel.coinBalance)

            Spacer()

            Button {
                path.append(AppRoute.settings)
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(GameTheme.goldGradient)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.35))
                            .overlay(
                                Circle()
                                    .stroke(GameTheme.gold.opacity(0.6), lineWidth: 1.5)
                            )
                    )
                    .shadow(color: GameTheme.gold.opacity(0.35), radius: 6)
            }
            .buttonStyle(ScalePressStyle())
            .accessibilityLabel("Settings")
        }
    }
}

// MARK: - Shared visual helpers used across screens

struct VegasBackground: View {
    var body: some View {
        ZStack {
            GameTheme.backgroundGradient
                .ignoresSafeArea()

            Circle()
                .fill(GameTheme.neonPurple.opacity(0.35))
                .frame(width: 280, height: 280)
                .blur(radius: 60)
                .offset(x: -120, y: -220)

            Circle()
                .fill(GameTheme.neonBlue.opacity(0.22))
                .frame(width: 240, height: 240)
                .blur(radius: 50)
                .offset(x: 140, y: -80)

            Circle()
                .fill(GameTheme.neonPink.opacity(0.18))
                .frame(width: 200, height: 200)
                .blur(radius: 45)
                .offset(x: 80, y: 260)

            VStack {
                Spacer()
                CitySilhouette()
                    .fill(Color.black.opacity(0.35))
                    .frame(height: 120)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

struct CitySilhouette: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: 0, y: h * 0.55))
        path.addLine(to: CGPoint(x: w * 0.08, y: h * 0.55))
        path.addLine(to: CGPoint(x: w * 0.08, y: h * 0.30))
        path.addLine(to: CGPoint(x: w * 0.16, y: h * 0.30))
        path.addLine(to: CGPoint(x: w * 0.16, y: h * 0.48))
        path.addLine(to: CGPoint(x: w * 0.25, y: h * 0.48))
        path.addLine(to: CGPoint(x: w * 0.25, y: h * 0.18))
        path.addLine(to: CGPoint(x: w * 0.34, y: h * 0.18))
        path.addLine(to: CGPoint(x: w * 0.34, y: h * 0.42))
        path.addLine(to: CGPoint(x: w * 0.45, y: h * 0.42))
        path.addLine(to: CGPoint(x: w * 0.45, y: h * 0.25))
        path.addLine(to: CGPoint(x: w * 0.55, y: h * 0.12))
        path.addLine(to: CGPoint(x: w * 0.65, y: h * 0.25))
        path.addLine(to: CGPoint(x: w * 0.65, y: h * 0.50))
        path.addLine(to: CGPoint(x: w * 0.78, y: h * 0.50))
        path.addLine(to: CGPoint(x: w * 0.78, y: h * 0.28))
        path.addLine(to: CGPoint(x: w * 0.90, y: h * 0.28))
        path.addLine(to: CGPoint(x: w * 0.90, y: h * 0.58))
        path.addLine(to: CGPoint(x: w, y: h * 0.58))
        path.addLine(to: CGPoint(x: w, y: h))
        path.closeSubpath()
        return path
    }
}

struct LuckyTapLogo: View {
    var size: CGFloat = 1.0

    var body: some View {
        VStack(spacing: -4 * size) {
            Text("Lucky")
                .font(.system(size: 42 * size, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [GameTheme.goldLight, GameTheme.gold, GameTheme.orangeButtonBottom],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: GameTheme.neonBlue.opacity(0.7), radius: 4)
                .shadow(color: .black.opacity(0.5), radius: 2, y: 2)

            Text("Tap")
                .font(.system(size: 48 * size, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: GameTheme.neonBlue.opacity(0.85), radius: 6)
                .shadow(color: .black.opacity(0.45), radius: 2, y: 2)
                .rotationEffect(.degrees(-4))
        }
        .overlay(alignment: .topTrailing) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 18 * size, weight: .bold))
                .foregroundStyle(Color.green)
                .rotationEffect(.degrees(25))
                .offset(x: 18 * size, y: 4 * size)
                .shadow(color: .green.opacity(0.6), radius: 4)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Lucky Tap")
    }
}
