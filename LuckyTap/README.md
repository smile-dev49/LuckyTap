# Lucky Tap — 555 Slots (SwiftUI)

Local virtual-coin entertainment slots game. No real-money gambling. No backend required for v1.

## Open & run

1. On a Mac, open `LuckyTap/LuckyTap.xcodeproj` in Xcode 15+.
2. Select an iPhone simulator (iOS 17+).
3. Set your Team under Signing if needed.
4. Press **Run**.

## App Store review notes (do these before submit)

1. In App Store Connect, set **Age Rating** for simulated gambling / casino (**usually 17+**).
2. Replace `AppLegal.privacyPolicyURL` and `AppLegal.supportEmail` with your real HTTPS privacy page and support email.
3. Add that same Privacy Policy URL in App Store Connect.
4. App description must say: entertainment only, virtual coins, no real money, no cash prizes.
5. Screenshots must match the app and not imply real-money payouts.
6. Do **not** add a fake “Buy Coins” button unless you implement Apple In-App Purchase.

## Screens

| Screen | Role |
|--------|------|
| **Home** | Branding, PLAY, shortcuts |
| **Game** | 3-reel slots, TAP / TAP TO STOP, bet, auto |
| **Achievements** | Lifetime badges / milestones |
| **Daily Reward** | 7-day login streak claim |
| **Missions** | Play tasks with coin rewards |
| **Profile** | Level, stats, collections |
| **Lucky Bonus** | Full-screen free spins |
| **Spin Wheel** | Full-screen daily wheel |
| **Settings** | Sound / haptics / privacy / terms / reset |

## Economy (current)

- Start coins: **1,100,000** (virtual only)
- Default bet: **110,000** (step 10,000 · min 10,000 · max 500,000)
- Symbols: **5**, clover, star, diamond, heart
- **555 jackpot**: 50× bet
- Progress saved in `UserDefaults` on device

## Project layout

```
LuckyTap/
  LuckyTapApp.swift
  Theme/          AppTheme + AppLegal
  Models/
  Services/       GameStore + SlotEngine
  Views/          Home, Game, Achievements, Profile, Bonus, Wheel, Settings, Compliance
  Assets.xcassets
```
