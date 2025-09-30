//
//  Card.swift
//  Card War
//
//  Created by Andrés Serna on 9/29/25.
//

import Foundation

enum Suit: String, CaseIterable {
    case hearts = "♥️"
    case diamonds = "♦️"
    case clubs = "♣️"
    case spades = "♠️"
    case none = "" // for jokers
}

enum Rank: Int, CaseIterable {
    case ace = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case jack = 11
    case queen = 12
    case king = 13
    case joker = 14
    
    var displayName: String {
        switch self {
        case .ace: return "A"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        case .joker: return "🃏"
        default: return "\(self.rawValue)"
        }
    }
}

struct Card: Identifiable, Equatable {
    let id = UUID()
    let rank: Rank
    let suit: Suit
    
    var displayString: String {
        if rank == .joker {
            return "🃏"
        }
        return "\(rank.displayName)\(suit.rawValue)"
    }
    
    // Compare cards according to game rules
    func beats(_ other: Card, kingInPlay: Bool) -> Bool {
        // Joker beats everything
        if self.rank == .joker {
            return true
        }
        if other.rank == .joker {
            return false
        }
        
        // Ace beats King when King is in play
        if kingInPlay {
            if self.rank == .ace && other.rank == .king {
                return true
            }
            if self.rank == .king && other.rank == .ace {
                return false
            }
        }
        
        // Otherwise, higher rank wins
        return self.rank.rawValue > other.rank.rawValue
    }
    
    static func == (leftSide: Card, rightSide: Card) -> Bool {
        return leftSide.id == rightSide.id
    }
}
