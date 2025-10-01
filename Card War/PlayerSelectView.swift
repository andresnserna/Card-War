//
//  PlayerSelectView.swift
//  Card War
//
//  Created by Andrés Serna on 9/29/25.
//

import Foundation
import SwiftUI

struct PlayerSelectView: View {
    @State private var selectedPlayers: Int = 2
    @State private var showGameView: Bool = false


    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
                .opacity(0.3)
            
            VStack {
                Text("Select number of players...")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 10)
                
                Slider(value: Binding(
                    get: { Double(selectedPlayers) },
                    set: { selectedPlayers = Int($0.rounded()) }
                ), in: 2...6, step: 1) {
                    Text("Players")
                } minimumValueLabel: {
                    Image(systemName: "person.fill")
                } maximumValueLabel: {
                    Image(systemName: "person.3.fill")
                }
                .padding()
                
                Text("\(selectedPlayers) Players")
                    .font(.title2)
                    .padding()
                
                //figure out how to make this view change to the game view
                Button(action: {
                    GameView(playerCount: selectedPlayers)
                }) {
                    Text("Start Game")
                        .fontWeight(.bold)
                        .padding()
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(style: StrokeStyle(lineWidth: 1))
                        })
                        
                }
            }
            .padding()
        }
    }
}

#Preview {
    PlayerSelectView()
}
