import Foundation
import AVFoundation

/// Lightweight sound helper. Compiles and runs safely even when audio files are missing.
@MainActor
final class SoundManager {
    static let shared = SoundManager()

    enum SoundEffect: String {
        case buttonTap = "sfx_button_tap"
        case reelSpin = "sfx_reel_spin"
        case reelStop = "sfx_reel_stop"
        case normalWin = "sfx_normal_win"
        case lucky555 = "sfx_lucky_555"
    }

    private var players: [SoundEffect: AVAudioPlayer] = [:]
    private var isEnabled = true

    private init() {
        preloadPlaceholders()
    }

    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }

    func play(_ effect: SoundEffect) {
        guard isEnabled else { return }

        if let player = players[effect] {
            player.currentTime = 0
            player.play()
            return
        }
    }

    private func preloadPlaceholders() {
        for effect in [SoundEffect.buttonTap, .reelSpin, .reelStop, .normalWin, .lucky555] {
            guard let url = Bundle.main.url(forResource: effect.rawValue, withExtension: "wav")
                    ?? Bundle.main.url(forResource: effect.rawValue, withExtension: "mp3") else {
                continue
            }

            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                players[effect] = player
            } catch {
                // Missing or invalid audio should never crash the app.
            }
        }
    }
}
