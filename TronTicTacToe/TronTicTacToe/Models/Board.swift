import Foundation

struct Board {
    static let winLines: [[Int]] = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        [0, 4, 8], [2, 4, 6]
    ]

    var cells: [Mark?] = Array(repeating: nil, count: 9)

    var availableMoves: [Int] {
        cells.indices.filter { cells[$0] == nil }
    }

    var isDraw: Bool {
        availableMoves.isEmpty && winner() == nil
    }

    func winner() -> (mark: Mark, cells: [Int])? {
        for line in Board.winLines {
            guard
                let first = cells[line[0]],
                cells[line[1]] == first,
                cells[line[2]] == first
            else { continue }
            return (first, line)
        }
        return nil
    }

    mutating func place(mark: Mark, at index: Int) {
        cells[index] = mark
    }
}
