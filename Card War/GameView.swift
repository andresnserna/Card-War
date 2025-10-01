//
//  GameView.swift
//  Card War
//
//  Created by Andrés Serna on 9/29/25.
//

import Foundation
import SwiftUI

struct GameView: View {
    @State var playerCount = 0
    
    var body: some View {
        ZStack {
            
            Image("background")
                .resizable()
                .ignoresSafeArea(edges: .all)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    //figure out how to make this view change to the help view
                    Button(action: {HelpView()}) {
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
            //main game stack
            VStack {
                Text("Player Count is: \(playerCount)")
                    .foregroundColor(.white)
                if playerCount == 2 {
                    
                } else if playerCount == 3 {
                    
                } else if playerCount == 4 {
                    
                } else if playerCount == 5 {
                    
                } else {
                    
                }
            }
            .padding()
        }
    }
}

#Preview {
    GameView()
}
