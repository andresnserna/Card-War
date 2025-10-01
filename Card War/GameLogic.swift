//
//  GameLogic.swift
//  Card War
//
//  Created by Andrés Serna on 9/29/25.
//

import Foundation
import SwiftUI

class GameLogic: ObservableObject {
    @Published var players: [Player]
    @Published var deck: Deck
    @Published var currentPhase: GamePhase
    @Published var drawnCards: [Card?]
    
    init(playerCount: Int) {
        // Initialize ALL stored properties first
        self.players = (0..<playerCount).map { number in
            return Player(id: number)
        }
        self.deck = Deck()
        self.currentPhase = GamePhase.drawing
        self.drawnCards = Array(repeating: nil, count: playerCount)
        
        // NOW you can use self
        self.deck.shuffle()
    }
    
    func drawCard(for playerIndex: Int) {
        guard let card = deck.drawCard() else { return }
        players[playerIndex].drawCard(card)
        drawnCards[playerIndex] = card
        
        // Check if all players have drawn
        if players.allSatisfy({ $0.hasDrawn }) {
            currentPhase = GamePhase.flipping
        }
    }
    
    func flipAllCards() {
        currentPhase = GamePhase.resolving
    }
    
    func resolveRound() {
        // TODO: Implement win logic
    }
}



enum GamePhase {
    case drawing
    case flipping
    case resolving
    case war // when there's a tie
    case gameOver
}
