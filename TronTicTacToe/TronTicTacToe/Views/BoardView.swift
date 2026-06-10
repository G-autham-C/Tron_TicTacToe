import SwiftUI

struct BoardView: View {
    var viewModel: GameViewModel

    @State private var lp0: CGFloat = 0
    @State private var lp1: CGFloat = 0
    @State private var lp2: CGFloat = 0
    @State private var lp3: CGFloat = 0
    @State private var scanlineY: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let boardSize = min(geo.size.width, geo.size.height) * 0.9
            let cellSize = boardSize / 3

            ZStack {
                scanline(boardSize: boardSize)

                LazyVGrid(columns: Array(repeating: GridItem(.fixed(cellSize)), count: 3), spacing: 0) {
                    ForEach(0..<9, id: \.self) { i in
                        CellView(
                            mark: viewModel.board.cells[i],
                            isWinningCell: isWinningCell(i),
                            onTap: { viewModel.humanTap(at: i) }
                        )
                        .frame(width: cellSize, height: cellSize)
                    }
                }
                .frame(width: boardSize, height: boardSize)

                gridLines(boardSize: boardSize)
                    .frame(width: boardSize, height: boardSize)
                    .allowsHitTesting(false)

                if case .won(_, let cells) = viewModel.gameState {
                    WinLineView(winCells: cells, boardSize: boardSize)
                        .frame(width: boardSize, height: boardSize)
                        .allowsHitTesting(false)
                }
            }
            .frame(width: boardSize, height: boardSize)
            .background(TronTheme.background)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
            .onAppear {
                startBootAnimation(boardSize: boardSize)
            }
            .onChange(of: viewModel.gameState) { _, newState in
                if case .playing = newState {
                    lp0 = 0; lp1 = 0; lp2 = 0; lp3 = 0
                    scanlineY = 0
                    startBootAnimation(boardSize: boardSize)
                }
            }
        }
    }

    @ViewBuilder
    private func gridLines(boardSize: CGFloat) -> some View {
        let stroke = StrokeStyle(lineWidth: 10, lineCap: .round)
        let color = TronTheme.playerX
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: boardSize / 3, y: 0))
                path.addLine(to: CGPoint(x: boardSize / 3, y: boardSize))
            }
            .trim(from: 0, to: lp0)
            .stroke(color, style: stroke)
            .neonGlow(color: color, radius: 10)

            Path { path in
                path.move(to: CGPoint(x: boardSize * 2 / 3, y: 0))
                path.addLine(to: CGPoint(x: boardSize * 2 / 3, y: boardSize))
            }
            .trim(from: 0, to: lp1)
            .stroke(color, style: stroke)
            .neonGlow(color: color, radius: 10)

            Path { path in
                path.move(to: CGPoint(x: 0, y: boardSize / 3))
                path.addLine(to: CGPoint(x: boardSize, y: boardSize / 3))
            }
            .trim(from: 0, to: lp2)
            .stroke(color, style: stroke)
            .neonGlow(color: color, radius: 10)

            Path { path in
                path.move(to: CGPoint(x: 0, y: boardSize * 2 / 3))
                path.addLine(to: CGPoint(x: boardSize, y: boardSize * 2 / 3))
            }
            .trim(from: 0, to: lp3)
            .stroke(color, style: stroke)
            .neonGlow(color: color, radius: 10)
        }
    }

    @ViewBuilder
    private func scanline(boardSize: CGFloat) -> some View {
        Rectangle()
            .fill(TronTheme.playerX.opacity(0.3))
            .frame(width: boardSize, height: 2)
            .offset(y: scanlineY - boardSize / 2)
            .clipped()
    }

    private func isWinningCell(_ i: Int) -> Bool {
        if case .won(_, let cells) = viewModel.gameState {
            return cells.contains(i)
        }
        return false
    }

    private func startBootAnimation(boardSize: CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.00) { withAnimation(.easeInOut(duration: 0.4)) { lp0 = 1.0 } }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { withAnimation(.easeInOut(duration: 0.4)) { lp1 = 1.0 } }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) { withAnimation(.easeInOut(duration: 0.4)) { lp2 = 1.0 } }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { withAnimation(.easeInOut(duration: 0.4)) { lp3 = 1.0 } }
        withAnimation(.easeIn(duration: 0.8)) { scanlineY = boardSize }
    }
}
