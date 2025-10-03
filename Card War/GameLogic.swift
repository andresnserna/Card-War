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
    @Published var currentPlayerIndex: Int = 0
    @Published var drawnCards: [Card] = []
    @Published var currentMessage: String = ""
    @Published var finalScoresMessage: String = ""
    
    init(playerCount: Int) {
        self.players = (0..<playerCount).map { number in
            return Player(id: number)
        }
        self.deck = Deck()
        self.currentPhase = .drawing
        self.drawnCards = [] // CHANGE from Array(repeating: nil, count: playerCount)
        
        self.deck.shuffle()
        self.currentMessage = "Player 1: Tap the deck to draw a card" // ADD THIS
    }
    
    // REPLACE drawCard function with this:
    func drawCardForCurrentPlayer() {
        guard currentPhase == .drawing else { return }
        guard let card = deck.drawCard() else {
            currentPhase = .gameOver
            determineGameWinner()
            return
        }
        
        players[currentPlayerIndex].drawCard(card)
        drawnCards.append(card)
        
        // Move to next player
        currentPlayerIndex += 1
        
        // Check if all players have drawn
        if currentPlayerIndex >= players.count {
            currentPhase = .flipping
            currentMessage = "Flipping cards..."
            
            // Auto-flip after 0.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.flipAllCards()
            }
        } else {
            currentMessage = "Player \(currentPlayerIndex + 1): Tap the deck to draw a card"
        }
    }
    
    // REPLACE flipAllCards function with this:
    func flipAllCards() {
        guard currentPhase == .flipping else { return }
        currentPhase = .resolving
        
        for player in players {
            player.flipCard()
        }
        
        // Small delay to show the flip, then resolve
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.resolveRound()
        }
    }
    
    func resolveRound() {
        guard currentPhase == .resolving else { return }
        
        // Check if King is in play (for Ace beats King rule)
        let kingInPlay = drawnCards.contains { $0.rank == .king }
        
        // Find the winning card(s)
        let winningCard = drawnCards.max { card1, card2 in
            // If king in play and comparing ace vs king
            if kingInPlay {
                if card1.rank == .ace && card2.rank == .king { return false }
                if card1.rank == .king && card2.rank == .ace { return true }
            }
            return card1.rank.rawValue < card2.rank.rawValue
        }
        
        guard let winner = winningCard else { return }
        
        // Find all players with the winning card (for ties)
        let winningPlayerIndices = drawnCards.enumerated().compactMap { index, card in
            card.rank == winner.rank ? index : nil
        }
        
        if winningPlayerIndices.count > 1 {
            // WAR!
            handleWar(tiedPlayers: winningPlayerIndices)
        } else {
            // Single winner
            let winnerIndex = winningPlayerIndices[0]
            players[winnerIndex].collectCards(drawnCards)
            
            let winnerName = players[winnerIndex].displayName
            let cardCount = players[winnerIndex].cardCount
            currentMessage = "\(winnerName) wins with \(winner.displayString)! Total cards: \(cardCount)"
            
            // Reset for next round after showing result
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.startNextRound()
            }
        }
    }
    
    func handleWar(tiedPlayers: [Int]) {
        currentPhase = .war
        
        let playerNames = tiedPlayers.map { "Player \($0 + 1)" }.joined(separator: " and ")
        currentMessage = "WAR between \(playerNames)!"
        
        // In a war, tied players draw again
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            var warCards: [Card] = []
            var warPlayerIndices: [Int] = []
            
            for playerIndex in tiedPlayers {
                if let card = self.deck.drawCard() {
                    self.players[playerIndex].drawCard(card)
                    warCards.append(card)
                    warPlayerIndices.append(playerIndex)
                }
            }
            
            if warCards.isEmpty {
                // No more cards, end game
                self.currentPhase = .gameOver
                self.determineGameWinner()
                return
            }
            
            // Add war cards to the pool
            self.drawnCards.append(contentsOf: warCards)
            
            // Find war winner
            let kingInPlay = self.drawnCards.contains { $0.rank == .king }
            let winningCard = warCards.max { card1, card2 in
                if kingInPlay {
                    if card1.rank == .ace && card2.rank == .king { return false }
                    if card1.rank == .king && card2.rank == .ace { return true }
                }
                return card1.rank.rawValue < card2.rank.rawValue
            }
            
            guard let warWinner = winningCard else { return }
            
            let warWinnerIndices = warCards.enumerated().compactMap { index, card in
                card.rank == warWinner.rank ? warPlayerIndices[index] : nil
            }
            
            if warWinnerIndices.count > 1 {
                // Another war!
                self.handleWar(tiedPlayers: warWinnerIndices)
            } else {
                // War resolved
                let winnerIndex = warWinnerIndices[0]
                self.players[winnerIndex].collectCards(self.drawnCards)
                
                let winnerName = self.players[winnerIndex].displayName
                let cardCount = self.players[winnerIndex].cardCount
                self.currentMessage = "\(winnerName) wins the war! Total cards: \(cardCount)"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.startNextRound()
                }
            }
        }
    }
    
    func startNextRound() {
        // Check if deck is empty
        if deck.isEmpty {
            currentPhase = .gameOver
            determineGameWinner()
            return
        }
        
        // Reset for next round
        currentPlayerIndex = 0
        drawnCards.removeAll()
        
        for player in players {
            player.resetForNextRound()
        }
        
        currentPhase = .drawing
        currentMessage = "Player 1: Tap the deck to draw a card"
    }
    
    func determineGameWinner() {
        let sortedPlayers = players.sorted { $0.cardCount > $1.cardCount }
        
        var resultMessage = "Final Scores:\n\n" // CHANGE THIS LINE
        for (index, player) in sortedPlayers.enumerated() {
            let prefix = index == 0 ? "🏆 " : ""
            resultMessage += "\(prefix)\(player.displayName): \(player.cardCount) cards\n"
        }
        
        finalScoresMessage = resultMessage // ADD THIS LINE
        currentMessage = "Game Over! \(sortedPlayers[0].displayName) wins!" // CHANGE THIS LINE
    }
    
    func resetGame() {
        deck.reset()
        currentPhase = .drawing
        currentPlayerIndex = 0
        drawnCards.removeAll()
        currentMessage = "Player 1: Tap the deck to draw a card"
        
        for player in players {
            player.collectedCards.removeAll()
            player.resetForNextRound()
        }
    }
}

enum GamePhase {
    case drawing
    case flipping
    case resolving
    case war
    case gameOver
}
