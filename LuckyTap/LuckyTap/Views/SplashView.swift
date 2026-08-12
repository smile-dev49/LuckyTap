import SwiftUI

/// Splash flow: App icon → Brand logo → loading progress → finish.
struct SplashView: View {
    var onFinished: () -> Void

    private enum Phase {
        case appIcon
        case brandLogo
        case loading
    }

    @State private var phase: Phase = .appIcon
    @State private var iconScale: CGFloat = 0.86
    @State private var iconOpacity: Double = 0
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
                ZStack {
                    // Phase 1: remote / app icon
                    appIconBlock
                        .opacity(phase == .appIcon ? iconOpacity : 0)
                        .scaleEffect(phase == .appIcon ? iconScale : 0.9)
                        .allowsHitTesting(false)

                    // Phase 2+: brand logo PNG
                    Image("BrandLogo")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300)
                        .shadow(color: AppTheme.gold.opacity(0.35), radius: 18)
                        .opacity(brandOpacity)
                        .scaleEffect(brandScale)
                }
                .frame(height: 280)

                // Phase 3: load progress under logo
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

    private var appIconBlock: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(AppTheme.gold.opacity(0.18))
                .frame(width: 170, height: 170)
                .blur(radius: 16)
                .scaleEffect(glowPulse ? 1.1 : 0.96)

            Image("AppLogo")
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
                .frame(width: 148, height: 148)
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(AppTheme.goldGradient, lineWidth: 3)
                )
                .shadow(color: AppTheme.gold.opacity(0.45), radius: 16, y: 6)
        }
    }

    private func runSequence() {
        Task { @MainActor in
            // 1) Show app / remote icon
            withAnimation(.spring(response: 0.65, dampingFraction: 0.75)) {
                iconOpacity = 1
                iconScale = 1
            }
            try? await Task.sleep(nanoseconds: 1_000_000_000)

            // 2) Fade icon out, show brand logo PNG
            withAnimation(.easeInOut(duration: 0.35)) {
                iconOpacity = 0
                phase = .brandLogo
            }
            try? await Task.sleep(nanoseconds: 120_000_000)

            withAnimation(.spring(response: 0.7, dampingFraction: 0.78)) {
                brandOpacity = 1
                brandScale = 1
            }
            try? await Task.sleep(nanoseconds: 650_000_000)

            // 3) Progress bar under logo
            withAnimation(.easeInOut(duration: 0.3)) {
                showProgress = true
                phase = .loading
            }

            let steps = 28
            for i in 1...steps {
                try? await Task.sleep(nanoseconds: 45_000_000)
                withAnimation(.linear(duration: 0.05)) {
                    progress = Double(i) / Double(steps)
                }
            }

            try? await Task.sleep(nanoseconds: 250_000_000)
            onFinished()
        }
    }
}
