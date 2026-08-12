import SwiftUI

struct CoinBadge: View {
    let amount: Int
    var showPlus: Bool = false
    var onPlus: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.95, green: 0.95, blue: 0.98), Color(red: 0.7, green: 0.72, blue: 0.78)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 24, height: 24)
                Text("🪙")
                    .font(.system(size: 14))
            }

            Text(GameStore.format(amount))
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundStyle(AppTheme.goldGradient)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            if showPlus {
                Button(action: { onPlus?() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.black)
                        .frame(width: 22, height: 22)
                        .background(AppTheme.goldGradient)
                        .clipShape(Circle())
                        .shadow(color: AppTheme.gold.opacity(0.45), radius: 4, y: 1)
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, showPlus ? 8 : 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.42))
                .overlay(
                    Capsule()
                        .stroke(AppTheme.gold.opacity(0.6), lineWidth: 1.4)
                )
                .shadow(color: .black.opacity(0.3), radius: 6, y: 2)
        )
    }
}

struct ProgressBarView: View {
    var progress: Double
    var fill: Color = AppTheme.neonGreen
    var height: CGFloat = 10

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.black.opacity(0.45))
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [fill, fill.opacity(0.75)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(0, geo.size.width * min(1, max(0, progress))))
                    .animation(.easeOut(duration: 0.35), value: progress)
            }
        }
        .frame(height: height)
    }
}

struct ScreenHeader: View {
    let title: String
    var icon: String? = nil
    var trailing: AnyView? = nil

    var body: some View {
        HStack {
            HStack(spacing: 8) {
                if let icon {
                    Text(icon).font(.title2)
                }
                Text(title)
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundStyle(AppTheme.goldGradient)
            }
            Spacer()
            if let trailing {
                trailing
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 8)
    }
}

struct PrimaryButton: View {
    let title: String
    var gradient: LinearGradient = AppTheme.playGradient
    var height: CGFloat = 54
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(gradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.white.opacity(0.35), lineWidth: 1.5)
                    )
                    .shadow(color: AppTheme.goldDark.opacity(0.55), radius: 10, y: 4)

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.25), .clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )

                Text(title)
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
        }
        .buttonStyle(PressableButtonStyle(scale: 0.96))
    }
}

struct SymbolTile: View {
    let symbol: SlotSymbol
    var size: CGFloat = 72

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(red: 0.93, green: 0.93, blue: 0.96)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.2), radius: 3, y: 2)

            if symbol == .five {
                Text("5")
                    .font(.system(size: size * 0.55, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(red: 1.0, green: 0.28, blue: 0.28), Color(red: 0.82, green: 0.05, blue: 0.12)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .red.opacity(0.35), radius: 2)
            } else {
                Text(symbol.emoji)
                    .font(.system(size: size * 0.45))
            }
        }
        .frame(width: size, height: size * 1.12)
        .overlay(
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .stroke(AppTheme.gold.opacity(0.7), lineWidth: 1.8)
        )
    }
}
