import SwiftUI

struct SpinWheelView: View {
    @EnvironmentObject private var store: GameStore
    var onClose: () -> Void
    @State private var rotation: Double = 0
    @State private var prize: Int?
    @State private var spinning = false

    private let segments = [5_000, 10_000, 25_000, 50_000, 100_000, 15_000, 8_000, 30_000]
    private let colors: [Color] = [
        .red, AppTheme.gold, AppTheme.neonBlue, AppTheme.neonGreen,
        .purple, .orange, AppTheme.hotPink, Color.cyan
    ]

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.35))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    Text("SPIN WHEEL")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(AppTheme.goldGradient)
                    Spacer()
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal, 18)

                Text("Spins left today: \(store.player.wheelSpinsLeft)")
                    .font(.subheadline.bold())
                    .foregroundColor(.white.opacity(0.75))

                ZStack {
                    Image(systemName: "arrowtriangle.down.fill")
                        .foregroundColor(AppTheme.gold)
                        .font(.title)
                        .offset(y: -150)
                        .zIndex(2)

                    WheelShape(segments: segments.count, colors: colors)
                        .frame(width: 280, height: 280)
                        .overlay(
                            ForEach(Array(segments.enumerated()), id: \.offset) { i, value in
                                Text(short(value))
                                    .font(.system(size: 11, weight: .heavy))
                                    .foregroundColor(.white)
                                    .rotationEffect(.degrees(Double(i) * 45 + 22.5))
                                    .offset(y: -95)
                                    .rotationEffect(.degrees(Double(i) * -45 - 22.5))
                            }
                        )
                        .rotationEffect(.degrees(rotation))
                        .shadow(color: AppTheme.gold.opacity(0.4), radius: 16)
                        .goldBorder(cornerRadius: 140, lineWidth: 4)
                }
                .frame(height: 320)

                if let prize {
                    Text("You won \(GameStore.format(prize)) coins!")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(AppTheme.gold)
                        .padding()
                        .background(AppTheme.panel)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Spacer()

                PrimaryButton(title: spinning ? "SPINNING..." : "SPIN") {
                    guard !spinning, store.player.wheelSpinsLeft > 0 else { return }
                    spinning = true
                    prize = nil
                    let extra = Double.random(in: 720...1440)
                    withAnimation(.easeOut(duration: 3.2)) {
                        rotation += extra
                    }
                    Task {
                        try? await Task.sleep(nanoseconds: 3_300_000_000)
                        if let p = store.spinWheel() {
                            prize = p
                        }
                        spinning = false
                    }
                }
                .padding(.horizontal, 40)
                .disabled(store.player.wheelSpinsLeft <= 0 || spinning)
                .opacity(store.player.wheelSpinsLeft <= 0 ? 0.5 : 1)

                Text("One free spin per day")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.45))
                    .padding(.bottom, 28)
            }
        }
    }

    private func short(_ v: Int) -> String {
        v >= 1000 ? "\(v / 1000)K" : "\(v)"
    }
}

struct WheelShape: View {
    let segments: Int
    let colors: [Color]

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2
            let slice = Angle.degrees(360 / Double(segments))
            for i in 0..<segments {
                var path = Path()
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: slice * Double(i) - .degrees(90),
                    endAngle: slice * Double(i + 1) - .degrees(90),
                    clockwise: false
                )
                path.closeSubpath()
                context.fill(path, with: .color(colors[i % colors.count].opacity(0.85)))
                context.stroke(path, with: .color(.white.opacity(0.35)), lineWidth: 1)
            }
            let hub = Path(ellipseIn: CGRect(x: center.x - 18, y: center.y - 18, width: 36, height: 36))
            context.fill(hub, with: .color(AppTheme.gold))
        }
    }
}
