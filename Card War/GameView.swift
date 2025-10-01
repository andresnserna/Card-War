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
        .sheet(isPresented: $showHelp) {
            HelpView(playerCount: playerCount)
        }
    }
}

#Preview {
    GameView(playerCount: 2)
}
