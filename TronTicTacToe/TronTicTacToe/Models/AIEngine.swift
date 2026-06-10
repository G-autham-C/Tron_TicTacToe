import Foundation

enum AIEngine {
    static func move(for board: Board, mark: Mark, difficulty: Difficulty) -> Int {
        switch difficulty {
        case .easy:   return easyMove(for: board)
        case .medium: return mediumMove(for: board, mark: mark)
        case .hard:   return hardMove(for: board, mark: mark)
        }
    }

    private static func easyMove(for board: Board) -> Int {
        board.availableMoves.randomElement()!
    }

    private static func mediumMove(for board: Board, mark: Mark) -> Int {
        if let win = winningMove(for: board, mark: mark) { return win }
        if let block = winningMove(for: board, mark: mark.opponent) { return block }
        if board.cells[4] == nil { return 4 }
        let corners = [0, 2, 6, 8].filter { board.cells[$0] == nil }
        if let corner = corners.randomElement() { return corner }
        return easyMove(for: board)
    }

    private static func winningMove(for board: Board, mark: Mark) -> Int? {
        for index in board.availableMoves {
            var copy = board
            copy.place(mark: mark, at: index)
            if copy.winner()?.mark == mark { return index }
        }
        return nil
    }

    private static func hardMove(for board: Board, mark: Mark) -> Int {
        var bestScore = Int.min
        var bestIndex = board.availableMoves.first!
        for index in board.availableMoves {
            var copy = board
            copy.place(mark: mark, at: index)
            let score = minimax(&copy, mark: mark.opponent, maximizing: false,
                                aiMark: mark, alpha: Int.min, beta: Int.max)
            if score > bestScore {
                bestScore = score
                bestIndex = index
            }
        }
        return bestIndex
    }

    private static func minimax(_ board: inout Board,
                                 mark: Mark,
                                 maximizing: Bool,
                                 aiMark: Mark,
                                 alpha: Int,
                                 beta: Int) -> Int {
        if let result = board.winner() {
            return result.mark == aiMark ? 10 : -10
        }
        if board.isDraw { return 0 }

        var alpha = alpha
        var beta = beta

        if maximizing {
            var best = Int.min
            for index in board.availableMoves {
                board.cells[index] = mark
                let score = minimax(&board, mark: mark.opponent, maximizing: false,
                                    aiMark: aiMark, alpha: alpha, beta: beta)
                board.cells[index] = nil
                best = max(best, score)
                alpha = max(alpha, best)
                if beta <= alpha { break }
            }
            return best
        } else {
            var best = Int.max
            for index in board.availableMoves {
                board.cells[index] = mark
                let score = minimax(&board, mark: mark.opponent, maximizing: true,
                                    aiMark: aiMark, alpha: alpha, beta: beta)
                board.cells[index] = nil
                best = min(best, score)
                beta = min(beta, best)
                if beta <= alpha { break }
            }
            return best
        }
    }
}
