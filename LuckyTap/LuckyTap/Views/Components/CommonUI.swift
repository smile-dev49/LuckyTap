import SwiftUI

struct CoinBadge: View {
    let amount: Int
    var showPlus: Bool = false
    var onPlus: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 6) {
            Text("🪙")
                .font(.system(size: 16))
            Text(GameStore.format(amount))
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundColor(AppTheme.gold)
            if showPlus {
                Button(action: { onPlus?() }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(AppTheme.gold)
                        .font(.system(size: 18))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.35))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(AppTheme.gold.opacity(0.5), lineWidth: 1.5))
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
                    .fill(fill)
                    .frame(width: max(0, geo.size.width * min(1, max(0, progress))))
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
            Text(title)
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(gradient)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.35), lineWidth: 1.5)
                )
                .shadow(color: AppTheme.goldDark.opacity(0.55), radius: 10, y: 4)
        }
        .buttonStyle(.plain)
    }
}

struct SymbolTile: View {
    let symbol: SlotSymbol
    var size: CGFloat = 72

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(red: 0.92, green: 0.92, blue: 0.95)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            if symbol == .five {
                Text("5")
                    .font(.system(size: size * 0.55, weight: .black, design: .rounded))
                    .foregroundColor(Color(red: 0.9, green: 0.1, blue: 0.15))
                    .shadow(color: .red.opacity(0.4), radius: 2)
            } else {
                Text(symbol.emoji)
                    .font(.system(size: size * 0.45))
            }
        }
        .frame(width: size, height: size * 1.15)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppTheme.gold.opacity(0.65), lineWidth: 2)
        )
    }
}
