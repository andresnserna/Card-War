//
//  HelpView.swift
//  Card War
//
//  Created by Andrés Serna on 9/30/25.
//

import SwiftUI

struct HelpView: View {
    let playerCount: Int // ADD THIS LINE
    @Environment(\.dismiss) private var dismiss // ADD THIS LINE
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
                .opacity(0.3)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        // REPLACE the entire Button block with this:
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue)
                                .font(.headline)
                                .frame(idealWidth: 44, maxWidth: 44, idealHeight: 44, maxHeight: 44)
                            Text("Back")
                        }
                        Spacer()
                    }
                    Text("Game Rules")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                    
                    // Game Setup Section
                    Text("Setup")
                        .fontWeight(.bold)
                        .font(.title2)
                    
                    Text("Objective: Collect the most cards by the end of the game.")
                        .fontWeight(.semibold)
                    
                    Text("Players: 2 to 6 players can play.")
                    
                    Text("The Deck: The game uses a standard 54-card deck (52 regular cards plus 2 Jokers).")
                    
                    Text("At the start of the game, the deck is shuffled and placed face-down in the center of the playing area.")
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    // How to Play Section
                    Text("How to Play")
                        .fontWeight(.bold)
                        .font(.title2)
                    
                    Text("Drawing Phase")
                        .fontWeight(.bold)
                        .font(.title3)
                    
                    Text("The game proceeds in rounds. Each round follows these steps:")
                    
                    Text("Step 1: Draw Cards")
                        .fontWeight(.semibold)
                    
                    Text("• Player 1 taps the deck to draw one card and keeps it face-down.")
                    Text("• Player 2 taps the deck to draw one card and keeps it face-down.")
                    Text("• Player 3 taps the deck to draw one card and keeps it face-down.")
                    Text("• Continue until all players have drawn exactly one card.")
                    
                    Text("Important: Do not look at your card yet! Keep it face-down until all players have drawn.")
                        .fontWeight(.semibold)
                        .italic()
                    
                    Text("Revealing Phase")
                        .fontWeight(.bold)
                        .font(.title3)
                        .padding(.top, 10)
                    
                    Text("Step 2: Flip All Cards")
                        .fontWeight(.semibold)
                    
                    Text("• Once every player has drawn their card, all players flip their cards face-up at the same time.")
                    Text("• Now everyone can see what cards were drawn.")
                    
                    Text("Resolution Phase")
                        .fontWeight(.bold)
                        .font(.title3)
                        .padding(.top, 10)
                    
                    Text("Step 3: Determine the Winner")
                        .fontWeight(.semibold)
                    
                    Text("The player with the highest card wins the round and collects all the cards that were played.")
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    // Card Hierarchy Section
                    Text("Card Hierarchy (Who Wins)")
                        .fontWeight(.bold)
                        .font(.title2)
                    
                    Text("Standard Rules")
                        .fontWeight(.bold)
                        .font(.title3)
                    
                    Text("Cards are ranked from lowest to highest as follows:")
                    
                    Text("Lowest to Highest:")
                        .fontWeight(.semibold)
                    
                    Text("• Ace (normally the lowest card, value of 1)")
                    Text("• 2, 3, 4, 5, 6, 7, 8, 9, 10")
                    Text("• Jack (value of 11)")
                    Text("• Queen (value of 12)")
                    Text("• King (value of 13)")
                    
                    Text("Example: A 9 beats a 7. A Queen beats a 10. A King beats a Jack.")
                        .italic()
                    
                    Text("Special Rules")
                        .fontWeight(.bold)
                        .font(.title3)
                        .padding(.top, 10)
                    
                    Text("Jokers Beat Everything")
                        .fontWeight(.semibold)
                    
                    Text("• If you draw a Joker, you automatically win the round.")
                    Text("• Jokers are the most powerful card in the game.")
                    Text("• If two players both draw Jokers, see the \"Tie Situation\" rules below.")
                    
                    Text("Aces Beat Kings (Special Exception)")
                        .fontWeight(.semibold)
                        .padding(.top, 5)
                    
                    Text("• Normally, Aces are the lowest card in the deck.")
                    Text("• HOWEVER, if anyone in the round draws a King, then all Aces become powerful.")
                    Text("• When a King is in play, an Ace will ALWAYS beat the King.")
                    Text("• Example: Player 1 has an Ace, Player 2 has a King, Player 3 has a Queen. Player 1 wins because the Ace beats the King.")
                        .italic()
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    // Tie Situations Section
                    Text("Tie Situations (War!)")
                        .fontWeight(.bold)
                        .font(.title2)
                    
                    Text("What Happens in a Tie")
                        .fontWeight(.bold)
                        .font(.title3)
                    
                    Text("If two or more players draw cards with the same rank (same number or face), AND those cards are the highest in the round, then those players go to \"War.\"")
                    
                    Text("Example of a Tie:")
                        .fontWeight(.semibold)
                    
                    Text("• Player 1 draws a 7")
                    Text("• Player 2 draws a 9")
                    Text("• Player 3 draws a 9")
                    
                    Text("Players 2 and 3 are tied with the highest card (9). They go to War.")
                        .italic()
                    
                    Text("How War Works")
                        .fontWeight(.bold)
                        .font(.title3)
                        .padding(.top, 10)
                    
                    Text("Step 1: Only the tied players participate in the War. Other players sit out.")
                    
                    Text("Step 2: The tied players each draw one more card from the deck and keep it face-down.")
                    
                    Text("Step 3: Once both players have drawn, they flip their new cards at the same time.")
                    
                    Text("Step 4: Apply the same card hierarchy rules to determine the winner.")
                    
                    Text("Step 5: The winner of the War collects:")
                    Text("• All the cards from the original round (including the non-tied players' cards)")
                    Text("• All the cards from the War itself")
                    
                    Text("Multiple Wars")
                        .fontWeight(.semibold)
                        .padding(.top, 5)
                    
                    Text("If the War also results in a tie, the same players go to War again. Keep going until there is a clear winner.")
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    // Winning the Game Section
                    Text("Winning the Game")
                        .fontWeight(.bold)
                        .font(.title2)
                    
                    Text("The game continues until the deck runs out of cards.")
                        .fontWeight(.semibold)
                    
                    Text("Once there are no more cards to draw:")
                    
                    Text("1. Count how many cards each player has collected.")
                    Text("2. The player with the most cards wins the game!")
                    
                    Text("Example Final Scores:")
                        .fontWeight(.semibold)
                        .padding(.top, 5)
                    
                    Text("• Player 1: 18 cards")
                    Text("• Player 2: 22 cards ← Winner!")
                    Text("• Player 3: 14 cards")
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    // Quick Reference Section
                    Text("Quick Reference")
                        .fontWeight(.bold)
                        .font(.title2)
                    
                    Text("Turn Order")
                        .fontWeight(.semibold)
                    
                    Text("1. All players draw one card (keep face-down)")
                    Text("2. All players flip cards at the same time")
                    Text("3. Highest card wins and collects all cards")
                    Text("4. Repeat until deck is empty")
                    
                    Text("Card Power")
                        .fontWeight(.semibold)
                        .padding(.top, 5)
                    
                    Text("• Joker → Beats everything")
                    Text("• Ace → Beats King (only when a King is in play), otherwise lowest")
                    Text("• King → 13 (highest regular card)")
                    Text("• Queen → 12")
                    Text("• Jack → 11")
                    Text("• 10 through 2 → Face value")
                    
                    Text("In Case of Tie")
                        .fontWeight(.semibold)
                        .padding(.top, 5)
                    
                    Text("• Tied players draw again")
                    Text("• Same rules apply")
                    Text("• Winner takes all cards from both rounds")
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    // Strategy Tips Section
                    Text("Strategy Tips")
                        .fontWeight(.bold)
                        .font(.title2)
                    
                    Text("• Remember that Aces are usually weak, but become powerful when someone plays a King!")
                    Text("• Keep track of how many cards each player has collected. This tells you who is winning.")
                    Text("• Jokers are rare (only 2 in the deck), so they are very valuable.")
                    Text("• In a game with more players, ties are more common, which makes rounds more exciting!")
                    
                    Text("Good luck and have fun playing Card War!")
                        .fontWeight(.bold)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                }
                .padding()
            }
        }
    }
}

#Preview {
    HelpView(playerCount: 2)
}
