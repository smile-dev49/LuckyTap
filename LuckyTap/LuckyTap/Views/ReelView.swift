import SwiftUI

struct ReelView: View {
    let value: Int
    let isSpinning: Bool
    var emphasizeFive: Bool = true

    private var isSpecial: Bool {
        value == GameConfiguration.specialSymbol
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white,
                            Color(red: 0.95, green: 0.95, blue: 0.98)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.28), radius: 3, y: 2)

            if isSpinning {
                VStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { i in
                        Text("\(spinPreview(offset: i))")
                            .font(.system(size: 30, weight: .black, design: .serif))
                            .foregroundStyle(GameTheme.reelNumber.opacity(0.32 - Double(i) * 0.07))
                    }
                }
                .blur(radius: 1.4)
                .opacity(0.75)
            }

            Text("\(value)")
                .font(.system(size: isSpecial && emphasizeFive ? 58 : 50, weight: .black, design: .serif))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.25, blue: 0.25),
                            GameTheme.reelNumber,
                            Color(red: 0.65, green: 0.0, blue: 0.08)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: isSpecial ? GameTheme.reelNumber.opacity(0.55) : .clear, radius: 8)
                .scaleEffect(isSpinning ? 0.9 : 1.0)
                .offset(y: isSpinning ? 3 : 0)
                .animation(
                    isSpinning
                    ? .linear(duration: 0.08).repeatForever(autoreverses: true)
                    : .easeOut(duration: 0.15),
                    value: isSpinning
                )
                .accessibilityLabel("Reel \(value)")
        }
        .frame(maxWidth: .infinity)
        .frame(height: 118)
        .clipped()
    }

    private func spinPreview(offset: Int) -> Int {
        let values = GameConfiguration.reelValues
        let base = values.firstIndex(of: value) ?? 0
        return values[(base + offset) % values.count]
    }
}

struct SlotMachineView: View {
    let reels: [Int]
    let spinning: [Bool]
    var showLever: Bool = true

    @State private var lightPhase = false

    var body: some View {
        ZStack(alignment: .trailing) {
            VStack(spacing: 0) {
                // Marquee lights
                HStack(spacing: 5) {
                    ForEach(0..<13, id: \.self) { i in
                        Circle()
                            .fill(bulbColor(index: i))
                            .frame(width: 9, height: 9)
                            .shadow(color: GameTheme.gold.opacity(0.95), radius: 3)
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 10)

                HStack(spacing: 8) {
                    ForEach(0..<GameConfiguration.reelCount, id: \.self) { index in
                        ReelView(
                            value: reels.indices.contains(index) ? reels[index] : 5,
                            isSpinning: spinning.indices.contains(index) ? spinning[index] : false
                        )
                    }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.62, green: 0.42, blue: 0.10),
                                Color(red: 0.42, green: 0.24, blue: 0.06),
                                Color(red: 0.28, green: 0.14, blue: 0.04)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [GameTheme.goldLight, GameTheme.gold, GameTheme.goldDark],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 5
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    .padding(5)
            )
            .shadow(color: GameTheme.gold.opacity(0.55), radius: 18)
            .shadow(color: .black.opacity(0.45), radius: 12, y: 8)

            if showLever {
                VStack(spacing: 0) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.red.opacity(0.98), Color(red: 0.65, green: 0.05, blue: 0.1)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 26, height: 26)
                        .overlay(Circle().stroke(Color.white.opacity(0.35), lineWidth: 1.5))
                        .shadow(color: .red.opacity(0.7), radius: 5)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(GameTheme.goldGradient)
                        .frame(width: 10, height: 62)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                }
                .offset(x: 20, y: 10)
            }
        }
        .padding(.trailing, showLever ? 14 : 0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.45).repeatForever(autoreverses: true)) {
                lightPhase = true
            }
        }
    }

    private func bulbColor(index: Int) -> Color {
        let on = ((index % 2 == 0) && lightPhase) || ((index % 2 == 1) && !lightPhase)
        return on ? GameTheme.goldLight : GameTheme.goldDark.opacity(0.7)
    }
}
