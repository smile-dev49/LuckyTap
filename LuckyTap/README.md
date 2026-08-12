# Lucky Tap — 555 Slots (SwiftUI)

Local virtual-coin slot game based on your UI design. No backend. SDK hook-up can come later.

## Open & run

1. On a Mac, open `LuckyTap/LuckyTap.xcodeproj` in Xcode 15+.
2. Select an iPhone simulator (iOS 17+).
3. Set your Team under Signing if needed.
4. Press **Run**.

## Screens

| Screen | Role |
|--------|------|
| **Home** | Branding, PLAY, shortcuts |
| **Game** | 3-reel slots, TAP / TAP TO STOP, bet, auto |
| **Achievements** | Daily reward (7-day) + missions |
| **Profile** | Level, stats, collections |
| **Lucky Bonus** | Full-screen free spins |
| **Spin Wheel** | Full-screen daily wheel |
| **Settings** | Sound / haptics / reset |

## Economy (current)

- Start coins: **1,100,000**
- Default bet: **110,000** (step 10,000 · min 10,000 · max 500,000)
- Symbols: **5**, clover, star, diamond, heart
- **555 jackpot**: 50× bet
- Progress saved in `UserDefaults`

## Project layout

```
LuckyTap/
  LuckyTapApp.swift
  Theme/
  Models/
  Services/     GameStore + SlotEngine
  Views/        Home, Game, Rewards, Profile, Bonus, Wheel, Settings
  Assets.xcassets
```
