import Foundation

enum Mark: String {
    case x = "X"
    case o = "O"

    var opponent: Mark {
        self == .x ? .o : .x
    }
}

enum Difficulty: String, CaseIterable {
    case easy
    case medium
    case hard

    var displayName: String {
        switch self {
        case .easy:   return "Easy"
        case .medium: return "Medium"
        case .hard:   return "Hard"
        }
    }
}
