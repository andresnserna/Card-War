//
//  Deck.swift
//  Card War
//
//  Created by Andrés Serna on 9/29/25.
//

import Foundation

class Deck {
    private(set) var cards: [Card] = []
    
    init() {
        createDeck()
    }
    
    private func createDeck() {
        cards = []
        
        // Add all standard cards
        for suit in Suit.allCases where suit != .none {
            for rank in Rank.allCases where rank != .joker {
                cards.append(Card(rank: rank, suit: suit))
            }
        }
        
        // Add 2 jokers
        cards.append(Card(rank: .joker, suit: .none))
        cards.append(Card(rank: .joker, suit: .none))
    }
    
    func shuffle() {
        cards.shuffle()
    }
    
    func drawCard() -> Card? {
        guard !cards.isEmpty else { return nil }
        return cards.removeFirst()
    }
    
    var count: Int {
        return cards.count
    }
    
    var isEmpty: Bool {
        return cards.isEmpty
    }
    
    // Reset and reshuffle the deck
    func reset() {
        createDeck()
        shuffle()
    }
}
