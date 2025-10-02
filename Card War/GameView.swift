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
    let currentMessage: String = "Player 1: Draw a card"
    let bottomOffset: CGFloat = 300
    @StateObject private var gameLogic: GameLogic
    @State private var showHelp = false
    @Environment(\.dismiss) private var dismiss
    @State private var showEndGameAlert = false
    @Namespace private var cardAnimation
    @State private var showGameOverAlert = false
    
    init(playerCount: Int) {
            self.playerCount = playerCount
            _gameLogic = StateObject(wrappedValue: GameLogic(playerCount: playerCount))
    }
    
    private func cardPosition(for playerIndex: Int) -> CGPoint {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        switch playerCount {
        case 2:
            switch playerIndex {
            case 0: return CGPoint(x: screenWidth / 2, y: 100) // top
            case 1: return CGPoint(x: screenWidth / 2, y: screenHeight - bottomOffset) // bottom
            default: return .zero
            }
            
        case 3:
            switch playerIndex {
            case 0: return CGPoint(x: screenWidth * 0.25, y: 120) // top left
            case 1: return CGPoint(x: screenWidth * 0.75, y: 120) // top right
            case 2: return CGPoint(x: screenWidth / 2, y: screenHeight - bottomOffset) // bottom
            default: return .zero
            }
            
        case 4:
            switch playerIndex {
            case 0: return CGPoint(x: screenWidth / 2, y: 100) // top center
            case 1: return CGPoint(x: 80, y: screenHeight / 2) // left center
            case 2: return CGPoint(x: screenWidth - 80, y: screenHeight / 2) // right center
            case 3: return CGPoint(x: screenWidth / 2, y: screenHeight - bottomOffset) // bottom center
            default: return .zero
            }
            
        case 5:
            switch playerIndex {
            case 0: return CGPoint(x: screenWidth * 0.25, y: 120) // top left
            case 1: return CGPoint(x: screenWidth * 0.75, y: 120) // top right
            case 2: return CGPoint(x: 80, y: screenHeight / 2) // left center
            case 3: return CGPoint(x: screenWidth - 80, y: screenHeight / 2) // right center
            case 4: return CGPoint(x: screenWidth / 2, y: screenHeight - bottomOffset) // bottom
            default: return .zero
            }
            
        case 6:
            switch playerIndex {
            case 0: return CGPoint(x: screenWidth / 2, y: 100) // top center
            case 1: return CGPoint(x: 80, y: screenHeight * 0.33) // left upper third
            case 2: return CGPoint(x: 80, y: screenHeight * 0.67) // left lower third
            case 3: return CGPoint(x: screenWidth / 2, y: screenHeight - bottomOffset) // bottom center
            case 4: return CGPoint(x: screenWidth - 80, y: screenHeight * 0.67) // right lower third
            case 5: return CGPoint(x: screenWidth - 80, y: screenHeight * 0.33) // right upper third
            default: return .zero
            }
            
        default:
            return CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        }
    }
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea(edges: .all)
            
            ForEach(gameLogic.players.indices, id: \.self) { index in
                if let card = gameLogic.players[index].currentCard {
                    let position = cardPosition(for: index)
                    
                    ZStack {
                        if gameLogic.currentPhase == .drawing ||
                           (gameLogic.currentPhase == .flipping && !gameLogic.players[index].isFlipped) {
                            // Show card back
                            Image("card_back")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                        } else {
                            // Show card face
                            Image(card.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .transition(.scale)
                        }
                        
                        // Player label
                        Text(gameLogic.players[index].displayName)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(4)
                            .offset(y: 50)
                    }
                    .position(position)
                    .matchedGeometryEffect(id: "card-\(index)", in: cardAnimation)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: position)
                    .animation(.easeInOut(duration: 0.3), value: gameLogic.players[index].isFlipped)
                }
            }
            
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
                    .matchedGeometryEffect(id: "deck", in: cardAnimation)
                    .onTapGesture {
                        gameLogic.drawCardForCurrentPlayer()
                    }
                    .disabled(gameLogic.currentPhase != .drawing)
                
                Spacer()
                
                // Debug info
                Text(gameLogic.currentMessage)
                    .foregroundColor(.white)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: UIScreen.main.bounds.width / 2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
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
        .alert("Game Over!", isPresented: $showGameOverAlert) {
            Button("Leave", role: .destructive) {
                dismiss()
            }
            Button("Play Again") {
                gameLogic.resetGame()
            }
        } message: {
            Text(gameLogic.finalScoresMessage)
        }
        .sheet(isPresented: $showHelp) {
            HelpView(playerCount: playerCount)
        }
        .onChange(of: gameLogic.currentPhase) { oldPhase, newPhase in
            if newPhase == .gameOver {
                showGameOverAlert = true
            }
        }
    }
    
    private func endGame() {
            gameLogic.resetGame()
    }
}

#Preview {
    GameView(playerCount: 2)
}
