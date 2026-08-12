# Lucky Tap — iOS MVP

Virtual-coin casino casual game built with **SwiftUI + MVVM**. Offline only. Main symbol: **555**.

## Open in Xcode

1. Copy/open this folder on a Mac
2. Open `LuckyTap.xcodeproj`
3. Select an iPhone simulator
4. Press **Run** (⌘R)

Requires **Xcode 15+** / **iOS 17+**.

## Core flow

Home → PLAY → select BET → TAP → reels spin → win/lose → coins update

## Screens (MVP)

- Home
- Game (555 reels)
- Daily Reward
- Settings

## Config

Edit `LuckyTap/Models/GameConfiguration.swift` for:

- Starting balance (`100_000`)
- Bet options
- Payout multipliers
- Daily reward amounts

## Local save

`UserDefaults` via `PersistenceManager` stores coins, bet, daily streak, sound/vibration, best win.

## Sounds

Optional wav/mp3 names (safe if missing):

- `sfx_button_tap`
- `sfx_reel_spin`
- `sfx_reel_stop`
- `sfx_normal_win`
- `sfx_lucky_555`

## Assets

- **App Icon:** `icon.jpg` → `Assets.xcassets/AppIcon` (home-screen icon only)
- **In-app UI:** SwiftUI shapes, gradients, SF Symbols, and text — do **not** paste reference PNGs into screens
- Placeholder imageset names reserved for later custom art: `lucky_tap_logo`, `game_background`, `coin_icon`, `slot_frame`, `reel_5`

Design references stay in `DesignReferences/` for visual guidance only.
