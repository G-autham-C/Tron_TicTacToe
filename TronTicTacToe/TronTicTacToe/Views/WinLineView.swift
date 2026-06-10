import SwiftUI

struct WinLineView: View {
    let winCells: [Int]
    let boardSize: CGFloat

    @State private var progress: CGFloat = 0
    @State private var pulse: Bool = false

    var body: some View {
        let start = cellCenter(winCells[0])
        let end = cellCenter(winCells[2])

        ZStack {
            Path { path in
                path.move(to: start)
                path.addLine(to: end)
            }
            .trim(from: 0, to: progress)
            .stroke(TronTheme.winHighlight, lineWidth: 3)
            .neonGlow(color: TronTheme.winHighlight, radius: 14)
            .opacity(pulse ? 0.5 : 1.0)
            .animation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true), value: pulse)
        }
        .frame(width: boardSize, height: boardSize)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                progress = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                pulse = true
            }
        }
    }

    private func cellCenter(_ index: Int) -> CGPoint {
        let cellSize = boardSize / 3
        let lineWidth: CGFloat = 10
        let adjust = lineWidth / 4  // half the grid line bleeds into edge cells
        let row = index / 3
        let col = index % 3

        var x = CGFloat(col) * cellSize + cellSize / 2
        var y = CGFloat(row) * cellSize + cellSize / 2

        if col == 0 { x -= adjust }
        if col == 2 { x += adjust }
        if row == 0 { y -= adjust }
        if row == 2 { y += adjust }

        return CGPoint(x: x, y: y)
    }
}
