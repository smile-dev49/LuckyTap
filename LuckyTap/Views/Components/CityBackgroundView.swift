import SwiftUI

/// Shared neon city backdrop used across main tabs.
struct CityBackgroundView: View {
    var dimOpacity: Double = 0.35

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("HomeBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()

                LinearGradient(
                    colors: [
                        Color(red: 0.04, green: 0.02, blue: 0.12).opacity(0.45 + dimOpacity * 0.3),
                        Color.clear.opacity(0.2),
                        Color(red: 0.05, green: 0.02, blue: 0.14).opacity(0.55 + dimOpacity * 0.35)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                RadialGradient(
                    colors: [Color(red: 0.4, green: 0.15, blue: 0.8).opacity(0.16), .clear],
                    center: .top,
                    startRadius: 10,
                    endRadius: 360
                )
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
