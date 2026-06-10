import Foundation
import Observation

enum GameState: Equatable {
    case playing
    case won(mark: Mark, cells: [Int])
    case draw

    static func == (lhs: GameState, rhs: GameState) -> Bool {
        switch (lhs, rhs) {
        case (.playing, .playing): return true
        case (.draw, .draw): return true
        case (.won(let lm, let lc), .won(let rm, let rc)): return lm == rm && lc == rc
        default: return false
        }
    }
}

@Observable @MainActor final class GameViewModel {
    private(set) var board = Board()
    private(set) var gameState: GameState = .playing
    var difficulty: Difficulty = .medium
    private(set) var humanMark: Mark = .x
    private var aiMark: Mark { humanMark.opponent }
    private(set) var isAIThinking = false
    var scores: (human: Int, ai: Int, draws: Int) = (0, 0, 0)

    func humanTap(at index: Int) {
        guard gameState == .playing,
              board.cells[index] == nil,
              !isAIThinking else { return }
        board.place(mark: humanMark, at: index)
        SoundManager.shared.playMove()
        checkState()
        guard gameState == .playing else { return }
        isAIThinking = true
        Task {
            try? await Task.sleep(for: .seconds(0.6))
            performAIMove()
        }
    }

    private func performAIMove() {
        let index = AIEngine.move(for: board, mark: aiMark, difficulty: difficulty)
        board.place(mark: aiMark, at: index)
        SoundManager.shared.playMove()
        checkState()
        isAIThinking = false
    }

    private func checkState() {
        if let result = board.winner() {
            gameState = .won(mark: result.mark, cells: result.cells)
            if result.mark == humanMark {
                scores.human += 1
                SoundManager.shared.playWin()
            } else {
                scores.ai += 1
                SoundManager.shared.playLose()
            }
        } else if board.isDraw {
            gameState = .draw
            scores.draws += 1
            SoundManager.shared.playDraw()
        }
    }

    func resetGame() {
        board = Board()
        gameState = .playing
        isAIThinking = false
    }

    func resetScores() {
        scores = (0, 0, 0)
    }
}
