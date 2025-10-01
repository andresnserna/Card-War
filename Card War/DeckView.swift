//
//  DeckView.swift
//  Card War
//
//  Created by Andrés Serna on 10/1/25.
//

import SwiftUI

struct DeckView: View {
    let deck: Deck
    let frameSize: CGFloat = 120
    
    var body: some View {
        ZStack {
            // Display top 8-10 cards to create the stacked effect
            // We don't need to render all 52 cards, just enough to look full
            ForEach(0..<min(10, deck.count), id: \.self) { index in
                Image("card_back")
                    .resizable()
                    .scaledToFit()
                    .frame(width: frameSize, height: frameSize)
                    // Each card gets a very slight random-ish rotation
                    .rotationEffect(.degrees(randomRotation(for: index)))
                    // Slight offset to show depth
                    .offset(x: CGFloat(index) * 0.3, y: CGFloat(index) * 0.3)
            }
        }
    }
    
    // Generate consistent but varied rotations for each card
    private func randomRotation(for index: Int) -> Double {
        let rotations = [-2.5, 1.8, -1.2, 2.1, -0.8, 1.5, -2.0, 0.9, -1.7, 2.3]
        return rotations[index % rotations.count]
    }
}

#Preview {
    DeckView(deck: Deck())
}
