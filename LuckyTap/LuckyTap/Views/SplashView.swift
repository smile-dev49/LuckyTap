import SwiftUI

/// Splash: Brand logo + loading progress (~4.5s), then finish.
struct SplashView: View {
    var onFinished: () -> Void

    @State private var brandScale: CGFloat = 0.88
    @State private var brandOpacity: Double = 0
    @State private var progress: Double = 0
    @State private var glowPulse = false
    @State private var showProgress = false

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            Circle()
                .fill(AppTheme.gold.opacity(0.12))
                .frame(width: 280, height: 280)
                .blur(radius: 55)
                .offset(y: -40)
                .scaleEffect(glowPulse ? 1.08 : 0.94)

            Circle()
                .fill(AppTheme.neonBlue.opacity(0.12))
                .frame(width: 260, height: 260)
                .blur(radius: 50)
                .offset(x: 80, y: 180)
                .scaleEffect(glowPulse ? 0.95 : 1.08)

            VStack(spacing: 28) {
                Image("BrandLogo")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 320)
                    .shadow(color: AppTheme.gold.opacity(0.4), radius: 20)
                    .opacity(brandOpacity)
                    .scaleEffect(brandScale)
                    .frame(height: 260)

                if showProgress {
                    VStack(spacing: 10) {
                        ProgressBarView(
                            progress: progress,
                            fill: AppTheme.gold,
                            height: 12
                        )
                        .frame(width: 210)
                        .overlay(
                            Capsule()
                                .stroke(AppTheme.gold.opacity(0.45), lineWidth: 1)
                        )

                        Text("LOADING \(Int(progress * 100))%")
                            .font(.system(size: 12, weight: .heavy, design: .rounded))
                            .tracking(1.5)
                            .foregroundColor(AppTheme.gold.opacity(0.9))
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                glowPulse = true
            }
            runSequence()
        }
    }

    private func runSequence() {
        Task { @MainActor in
            // Show brand logo only (~4.5s total)
            withAnimation(.spring(response: 0.7, dampingFraction: 0.78)) {
                brandOpacity = 1
                brandScale = 1
            }
            try? await Task.sleep(nanoseconds: 700_000_000)

            withAnimation(.easeInOut(duration: 0.35)) {
                showProgress = true
            }

            // Progress fills over ~3.2s → total splash ~4.5s
            let steps = 40
            for i in 1...steps {
                try? await Task.sleep(nanoseconds: 80_000_000)
                withAnimation(.linear(duration: 0.08)) {
                    progress = Double(i) / Double(steps)
                }
            }

            try? await Task.sleep(nanoseconds: 350_000_000)
            onFinished()
        }
    }
}
