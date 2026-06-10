import SwiftUI

struct LinePath: Shape {
    let from: CGPoint
    let to: CGPoint
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: from)
        p.addLine(to: to)
        return p
    }
}

struct CellView: View {
    let mark: Mark?
    let isWinningCell: Bool
    let onTap: () -> Void

    @State private var drawProgress: CGFloat = 0
    @State private var drawProgress2: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let inset = size.width * 0.2

            ZStack {
                Color.clear

                if mark == .x {
                    let glowRadius: CGFloat = isWinningCell ? 12 : 6

                    ZStack {
                        LinePath(
                            from: CGPoint(x: inset, y: inset),
                            to: CGPoint(x: size.width - inset, y: size.height - inset)
                        )
                        .trim(from: 0, to: drawProgress)
                        .stroke(TronTheme.playerX, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .neonGlow(color: TronTheme.playerX, radius: glowRadius)

                        LinePath(
                            from: CGPoint(x: size.width - inset, y: inset),
                            to: CGPoint(x: inset, y: size.height - inset)
                        )
                        .trim(from: 0, to: drawProgress2)
                        .stroke(TronTheme.playerX, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .neonGlow(color: TronTheme.playerX, radius: glowRadius)
                    }
                } else if mark == .o {
                    let glowRadius: CGFloat = isWinningCell ? 12 : 6

                    Circle()
                        .trim(from: 0, to: drawProgress)
                        .stroke(TronTheme.playerO, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .padding(inset)
                        .neonGlow(color: TronTheme.playerO, radius: glowRadius)
                }
            }
            .onChange(of: mark) { _, newMark in
                if newMark == .x {
                    drawProgress = 0
                    drawProgress2 = 0
                    withAnimation(.easeOut(duration: 0.3)) {
                        drawProgress = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeOut(duration: 0.25)) {
                            drawProgress2 = 1.0
                        }
                    }
                } else if newMark == .o {
                    drawProgress = 0
                    withAnimation(.easeOut(duration: 0.3)) {
                        drawProgress = 1.0
                    }
                } else {
                    drawProgress = 0
                    drawProgress2 = 0
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if mark == nil {
                    onTap()
                }
            }
        }
    }
}
