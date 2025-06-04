//
//  ContentView.swift
//  SetGame
//
//  Created by Yonatan Shiftan on 27/05/2025.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var setGameViewModel: SetGameViewModel
  
  var body: some View {
    AspectVGrid(setGameViewModel.visibleCards, aspectRatio: 3/4, minItemWidth: 80) { card in
      CardView(card: card,
               isSelected: setGameViewModel.isCardSelected(card: card),
               chosenSetNotificationState: setGameViewModel.chosenSetNotificationState)
      .padding(.vertical, 3)
      .padding(.horizontal, 10)
      .onTapGesture {
        withAnimation(.easeInOut(duration: 0.5)) {
          setGameViewModel.handleCardPress(uuid: card.id)
        }
      }
    }
    
    
    HStack {
      Button("New Game") {
        setGameViewModel.newGame()
      }
      .padding(.horizontal, 4)
      
      
      VStack {
        Text("Deck")
        ZStack {
          ForEach(setGameViewModel.deckCards) { card in
            CardView(card: card, isSelected: false, chosenSetNotificationState: .none, isFaceDown: true)
              .frame(width: 70, height: 90)
              .onTapGesture { _ in
                setGameViewModel.askForMoreCards()
              }
          }
        }
        Spacer()
      }
      
      VStack {
        Text("discard pile")
        ZStack {
          ForEach(setGameViewModel.matchedCards) { card in
            CardView(card: card, isSelected: false, chosenSetNotificationState: .none)
              .frame(width: 70, height: 90)
          }
        }
        Spacer()
      }
    }
    .frame(height: 140)
    Text("Number of Cards in deck: \(setGameViewModel.deckCount)")
  }
}

#Preview {
  ContentView(setGameViewModel: SetGameViewModel(gameModel: SetGameModel()))
}
