import SwiftUI

struct GameView: View {
    @State private var viewModel = GameViewModel()

    var body: some View {
        ZStack {
            TronTheme.background
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("TIC TAC TOE")
                    .font(TronTheme.titleFont)
                    .foregroundStyle(TronTheme.playerX)
                    .neonGlow(color: TronTheme.playerX, radius: 12)

                Text("TRON EDITION")
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundStyle(TronTheme.playerX.opacity(0.6))

                Picker("Difficulty", selection: $viewModel.difficulty) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.displayName).tag(difficulty)
                    }
                }
                .pickerStyle(.segmented)
                .tint(TronTheme.playerX)
                .padding(.horizontal)
                .disabled(viewModel.gameState != .playing)

                Text("YOU: \(viewModel.scores.human)  DRAWS: \(viewModel.scores.draws)  AI: \(viewModel.scores.ai)")
                    .font(TronTheme.bodyFont)
                    .foregroundStyle(TronTheme.statusText.opacity(0.7))

                BoardView(viewModel: viewModel)

                StatusBarView(viewModel: viewModel)

                HStack(spacing: 16) {
                    Button {
                        viewModel.resetGame()
                    } label: {
                        Text("NEW GAME")
                            .font(.system(size: 14, weight: .semibold, design: .monospaced))
                            .foregroundStyle(TronTheme.playerX)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(TronTheme.playerX, lineWidth: 1.5)
                            )
                    }
                    .neonGlow(color: TronTheme.playerX)

                    Button {
                        viewModel.resetScores()
                    } label: {
                        Text("RESET SCORES")
                            .font(.system(size: 14, weight: .semibold, design: .monospaced))
                            .foregroundStyle(TronTheme.playerO)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(TronTheme.playerO, lineWidth: 1.5)
                            )
                    }
                    .neonGlow(color: TronTheme.playerO)
                }
                .padding(.bottom, 8)
            }
            .padding(.vertical, 24)
        }
    }
}
