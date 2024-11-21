import SwiftUI

import Combine

class GameState: ObservableObject {
    @Published var board: [[Tile]] = [
        [.empty, .empty, .empty],
        [.empty, .empty, .empty],
        [.empty, .empty, .empty]
    ]
    
    @Published var currentPlayer: Tile = .cross
    
    func makeMove(row: Int, col: Int) {
        if board[row][col] == .empty {
            board[row][col] = currentPlayer
            currentPlayer = currentPlayer == .cross ? .naught : .cross
        }
    }
    
    func checkWinner() -> Tile? {
   
        for i in 0..<3 {
            if board[i][0] != .empty && board[i][0] == board[i][1] && board[i][1] == board[i][2] {
                return board[i][0]
            }
            if board[0][i] != .empty && board[0][i] == board[1][i] && board[1][i] == board[2][i] {
                return board[0][i]
            }
        }
        
        if board[0][0] != .empty && board[0][0] == board[1][1] && board[1][1] == board[2][2] {
            return board[0][0]
        }
        
        if board[0][2] != .empty && board[0][2] == board[1][1] && board[1][1] == board[2][0] {
            return board[0][2]
        }
        
        return nil
    }
}

enum Tile {
    case cross, naught, empty
    
    var symbol: String {
        switch self {
        case .cross: return "X"
        case .naught: return "O"
        case .empty: return ""
        }
    }
}

struct ContentView: View {
    @ObservedObject var gameState = GameState()
    
    var body: some View {
        VStack {
            Text("Current Player: \(gameState.currentPlayer.symbol)")
                .font(.largeTitle)
                .padding()
            
            ForEach(0..<3) { row in
                HStack {
                    ForEach(0..<3) { col in
                        Button(action: {
                            gameState.makeMove(row: row, col: col)
                        }) {
                            Text(gameState.board[row][col].symbol)
                                .font(.system(size: 60))
                                .frame(width: 100, height: 100)
                                .background(Color.white)
                                .border(Color.black)
                        }
                    }
                }
            }
            
            if let winner = gameState.checkWinner() {
                Text("Winner: \(winner.symbol)")
                    .font(.largeTitle)
                    .padding()
            }
        }
        .padding()
    }
}
