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
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white,
                            Color(red: 0.94, green: 0.94, blue: 0.98)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.25), radius: 3, y: 2)

            // Vertical spin blur suggestion while spinning
            if isSpinning {
                VStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { i in
                        Text("\(spinPreview(offset: i))")
                            .font(.system(size: 28, weight: .black, design: .serif))
                            .foregroundStyle(GameTheme.reelNumber.opacity(0.35 - Double(i) * 0.08))
                    }
                }
                .blur(radius: 1.2)
                .opacity(0.7)
            }

            Text("\(value)")
                .font(.system(size: isSpecial && emphasizeFive ? 54 : 48, weight: .black, design: .serif))
                .foregroundStyle(GameTheme.reelNumber)
                .shadow(color: isSpecial ? GameTheme.reelNumber.opacity(0.45) : .clear, radius: 6)
                .scaleEffect(isSpinning ? 0.92 : 1.0)
                .offset(y: isSpinning ? 2 : 0)
                .animation(isSpinning ? .linear(duration: 0.08).repeatForever(autoreverses: true) : .easeOut(duration: 0.15), value: isSpinning)
                .accessibilityLabel("Reel \(value)")
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
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

    var body: some View {
        ZStack(alignment: .trailing) {
            VStack(spacing: 0) {
                // Marquee lights
                HStack(spacing: 6) {
                    ForEach(0..<11, id: \.self) { i in
                        Circle()
                            .fill(i % 2 == 0 ? GameTheme.goldLight : GameTheme.gold)
                            .frame(width: 8, height: 8)
                            .shadow(color: GameTheme.gold.opacity(0.9), radius: 3)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 8)

                HStack(spacing: 8) {
                    ForEach(0..<GameConfiguration.reelCount, id: \.self) { index in
                        ReelView(
                            value: reels.indices.contains(index) ? reels[index] : 5,
                            isSpinning: spinning.indices.contains(index) ? spinning[index] : false
                        )
                    }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
            }
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.35, green: 0.18, blue: 0.08),
                                Color(red: 0.55, green: 0.35, blue: 0.08),
                                Color(red: 0.28, green: 0.14, blue: 0.05)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(GameTheme.goldGradient, lineWidth: 4)
            )
            .shadow(color: GameTheme.gold.opacity(0.45), radius: 16)
            .shadow(color: .black.opacity(0.4), radius: 10, y: 6)

            if showLever {
                VStack(spacing: 0) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.red.opacity(0.95), Color(red: 0.7, green: 0.05, blue: 0.1)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 22, height: 22)
                        .shadow(color: .red.opacity(0.6), radius: 4)

                    RoundedRectangle(cornerRadius: 3)
                        .fill(GameTheme.goldGradient)
                        .frame(width: 8, height: 54)
                }
                .offset(x: 18, y: 8)
            }
        }
        .padding(.trailing, showLever ? 12 : 0)
    }
}
