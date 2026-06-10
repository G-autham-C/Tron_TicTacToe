# TRON Tic Tac Toe

A TRON-inspired Tic Tac Toe game for iOS built with SwiftUI. Dark backgrounds, neon cyan and orange glows, animated grid boot-up, and a synthesized electronic soundscape — all with zero third-party dependencies.

---

## Screenshots

> _Add screenshots here after running on device/simulator._

---

## Features

- **Solo vs AI** — play against the computer, offline only
- **3 difficulty levels** — Easy (random), Medium (heuristic), Hard (unbeatable minimax with alpha-beta pruning)
- **TRON aesthetic** — near-black background, cyan X, orange O, neon glowing grid
- **Animated pieces** — X draws as two crossing lines, O draws as an arc, both with neon glow on placement
- **Grid boot-up animation** — grid lines draw in sequentially on game start with a scanline sweep
- **Win line overlay** — pulsing line highlights the winning combination
- **Synthesised sound** — move clicks, win arpeggio, lose descending tones, draw buzz — all generated in-memory via AVAudioEngine, no audio files needed
- **Score tracking** — win/draw/loss tally persists across rounds

---

## Requirements

| Tool | Version |
|---|---|
| Xcode | 15.0+ |
| iOS Deployment Target | 17.0+ |
| Swift | 5.9+ |
| xcodegen | 2.x ([install](https://github.com/yonaskolb/XcodeGen)) |

---

## Getting Started

1. **Clone the repo**
   ```bash
   git clone https://github.com/YOUR_USERNAME/TronTicTacToe.git
   cd TronTicTacToe/TronTicTacToe
   ```

2. **Install xcodegen** (if not already)
   ```bash
   brew install xcodegen
   ```

3. **Generate the Xcode project**
   ```bash
   xcodegen generate
   ```

4. **Open and run**
   ```bash
   open TronTicTacToe.xcodeproj
   ```
   Select an iPhone simulator (iOS 17+) and press **Run**.

---

## Project Structure

```
TronTicTacToe/
├── project.yml                      ← xcodegen project definition
└── TronTicTacToe/
    ├── TronTicTacToeApp.swift        ← App entry point
    ├── Models/
    │   ├── Player.swift             ← Mark and Difficulty enums
    │   ├── Board.swift              ← Game state, win detection
    │   └── AIEngine.swift           ← Easy / Medium / Hard AI (minimax)
    ├── ViewModels/
    │   └── GameViewModel.swift      ← @Observable game orchestration
    ├── Views/
    │   ├── GameView.swift           ← Root layout, score display, buttons
    │   ├── BoardView.swift          ← 3×3 grid with boot-up animation
    │   ├── CellView.swift           ← Animated X and O rendering
    │   ├── WinLineView.swift        ← Pulsing win line overlay
    │   └── StatusBarView.swift      ← Turn / thinking / result status
    ├── Styling/
    │   └── TronTheme.swift          ← Colors, fonts, neonGlow modifier
    ├── Audio/
    │   └── SoundManager.swift       ← Synthesised tones via AVAudioEngine
    └── Assets.xcassets/
        └── AppIcon.appiconset/      ← TRON-themed app icon
```

---

## Architecture

The app follows **MVVM** with the iOS 17 `@Observable` macro:

- **Models** are pure value types (`struct`) with no UI dependencies
- **`GameViewModel`** is a `@MainActor @Observable` class that owns all mutable game state and orchestrates the AI move delay via `Task.sleep`
- **Views** read from `GameViewModel` directly — no property wrappers needed beyond `@State` on the root `GameView`

---

## AI Difficulty

| Level | Strategy |
|---|---|
| Easy | Random move from available cells |
| Medium | Win if possible → block opponent win → prefer centre → corners → random |
| Hard | Minimax with alpha-beta pruning — cannot be beaten |

---

## License

MIT
