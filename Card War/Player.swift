//
//  Player.swift
//  Card War
//
//  Created by Andrés Serna on 9/29/25.
//

import Foundation

class Player: Identifiable, ObservableObject {
    let id: Int
    @Published var collectedCards: [Card] = []
    @Published var currentCard: Card? = nil
    @Published var hasDrawn: Bool = false
    @Published var isFlipped: Bool = false
    
    var cardCount: Int {
        return collectedCards.count
    }
    
    init(id: Int) {
        self.id = id
    }
    
    func drawCard(_ card: Card) {
        self.currentCard = card
        self.hasDrawn = true
    }
    
    func flipCard() {
        isFlipped = true
    }
    
    func collectCards(_ cards: [Card]) {
        collectedCards.append(contentsOf: cards)
    }
    
    func resetForNextRound() {
        currentCard = nil
        hasDrawn = false
        isFlipped = false
    }
    
    var displayName: String {
        return "Player \(id + 1)"
    }
}
