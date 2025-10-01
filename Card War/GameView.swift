//
//  GameView.swift
//  Card War
//
//  Created by Andrés Serna on 9/29/25.
//

import Foundation
import SwiftUI

struct GameView: View {
    let playerCount: Int
    @StateObject private var gameLogic: GameLogic
    @State private var showHelp = false
    @Environment(\.dismiss) private var dismiss
    @State private var showEndGameAlert = false
    
    init(playerCount: Int) {
            self.playerCount = playerCount
            _gameLogic = StateObject(wrappedValue: GameLogic(playerCount: playerCount))
    }
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea(edges: .all)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showHelp = true }) {
                        Text("Help")
                            .padding()
                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(style: StrokeStyle(lineWidth: 1))
                            })
                            .foregroundColor(.white)
                    }
                    .padding()
                }
            }
            
            // Main game stack - deck in center
            VStack {
                Spacer()
                
                DeckView(deck: gameLogic.deck)
                    .onTapGesture {
                        // TODO: Handle card drawing
                        print("Deck tapped - \(gameLogic.deck.count) cards remaining")
                    }
                
                Spacer()
                
                // Debug info
                Text("\(gameLogic.deck.count) cards remaining")
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .navigationBarBackButtonHidden(true) // ADD THIS LINE
            .toolbar { // ADD THIS ENTIRE TOOLBAR BLOCK
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showEndGameAlert = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(style: StrokeStyle(lineWidth: 1))
                        })
                        .foregroundColor(.white)
                    }
                }
            }
            .alert("End Game?", isPresented: $showEndGameAlert) {
                Button("Cancel", role: .cancel) { }
                Button("End Game", role: .destructive) {
                    endGame()
                    dismiss()
                }
            } message: {
                Text("Going back will end the current game. Are you sure?")
            }
            .sheet(isPresented: $showHelp) {
                HelpView(playerCount: playerCount)
            }
    }
    
        private func endGame() {
            // Reset game state
            gameLogic.deck.reset()
            gameLogic.currentPhase = .drawing
            gameLogic.drawnCards = Array(repeating: nil, count: playerCount)
            
            // Reset all players
            for player in gameLogic.players {
                player.collectedCards.removeAll()
                player.resetForNextRound()
            }
        }
}

#Preview {
    GameView(playerCount: 2)
}
