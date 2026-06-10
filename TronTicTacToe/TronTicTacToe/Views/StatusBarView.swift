import SwiftUI

struct StatusBarView: View {
    var viewModel: GameViewModel
    @State private var pulse: Bool = false

    var body: some View {
        statusText
            .font(TronTheme.statusFont)
            .animation(.easeInOut, value: viewModel.gameState)
    }

    @ViewBuilder
    private var statusText: some View {
        switch viewModel.gameState {
        case .playing where viewModel.isAIThinking:
            Text("AI THINKING...")
                .foregroundStyle(TronTheme.playerO)
                .opacity(pulse ? 0.3 : 1.0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                        pulse = true
                    }
                }
                .onDisappear {
                    pulse = false
                }

        case .playing:
            Text("YOUR TURN")
                .foregroundStyle(TronTheme.playerX)

        case .won(let mark, _) where mark == viewModel.humanMark:
            Text("YOU WIN!")
                .foregroundStyle(TronTheme.playerX)
                .neonGlow(color: TronTheme.playerX, radius: 16)

        case .won:
            Text("AI WINS")
                .foregroundStyle(TronTheme.playerO)

        case .draw:
            Text("DRAW")
                .foregroundStyle(TronTheme.statusText)
        }
    }
}
