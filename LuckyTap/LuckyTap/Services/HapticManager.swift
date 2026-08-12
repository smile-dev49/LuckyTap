import UIKit

@MainActor
final class HapticManager {
    static let shared = HapticManager()

    private var isEnabled = true

    private init() {}

    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }

    func tap() {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    func reelStop() {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }

    func win() {
        guard isEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }

    func lucky555() {
        guard isEnabled else { return }
        let heavy = UIImpactFeedbackGenerator(style: .heavy)
        heavy.prepare()
        heavy.impactOccurred(intensity: 1.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { [weak self] in
            guard let self, self.isEnabled else { return }
            let notify = UINotificationFeedbackGenerator()
            notify.notificationOccurred(.success)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) { [weak self] in
            guard let self, self.isEnabled else { return }
            let pulse = UIImpactFeedbackGenerator(style: .rigid)
            pulse.impactOccurred(intensity: 0.9)
        }
    }
}
