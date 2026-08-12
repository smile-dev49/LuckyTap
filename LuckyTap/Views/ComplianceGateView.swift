import SwiftUI

/// First-run compliance gate: 17+ + virtual currency only acknowledgment.
struct ComplianceGateView: View {
    var onAccept: () -> Void

    @State private var isAdult = false
    @State private var understandsVirtual = false

    private var canContinue: Bool { isAdult && understandsVirtual }

    var body: some View {
        ZStack {
            CityBackgroundView(dimOpacity: 0.55)

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        Image("BrandLogo")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 240)
                            .frame(maxHeight: 110)
                            .frame(maxWidth: .infinity)

                        Text("Important Notice")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundStyle(AppTheme.goldGradient)
                            .frame(maxWidth: .infinity)

                        Text(AppLegal.ageNotice)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.white.opacity(0.9))

                        Text(AppLegal.fullDisclaimer)
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.75))
                            .fixedSize(horizontal: false, vertical: true)

                        checkRow(
                            "I confirm I am 17 years of age or older.",
                            isOn: $isAdult
                        )
                        checkRow(
                            "I understand coins are virtual only and have no real-world value.",
                            isOn: $understandsVirtual
                        )
                    }
                    .padding(20)
                    .padding(.bottom, 12)
                }

                VStack(spacing: 10) {
                    Button(action: onAccept) {
                        Text("I Agree — Continue")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                            .foregroundColor(canContinue ? .black : .white.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                canContinue
                                ? AnyShapeStyle(AppTheme.goldGradient)
                                : AnyShapeStyle(Color.white.opacity(0.15))
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .disabled(!canContinue)
                    .buttonStyle(PressableButtonStyle())

                    Text(AppLegal.shortDisclaimer)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.45))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
                .padding(.top, 8)
                .background(Color.black.opacity(0.35))
            }
        }
    }

    private func checkRow(_ title: String, isOn: Binding<Bool>) -> some View {
        Button {
            isOn.wrappedValue.toggle()
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isOn.wrappedValue ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundColor(isOn.wrappedValue ? AppTheme.neonGreen : .white.opacity(0.5))
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
            }
            .padding(12)
            .background(Color.black.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(AppTheme.gold.opacity(0.25), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct EntertainmentDisclaimerBar: View {
    var body: some View {
        Text(AppLegal.shortDisclaimer)
            .font(.system(size: 9, weight: .semibold))
            .foregroundColor(.white.opacity(0.55))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.35))
    }
}
