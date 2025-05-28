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
    AspectVGrid(setGameViewModel.visibleCards, aspectRatio: 1) { card in
      CardView(card: card, isSelected: setGameViewModel.isCardSelected(card: card), chosenSetNotificationState: setGameViewModel.chosenSetNotificationState)
        .onTapGesture {
          setGameViewModel.handleCardPress(uuid: card.id)
        }
    }
    HStack {
      Button("New Game") {
        setGameViewModel.newGame()
      }
      .padding(.horizontal, 4)
      Spacer()
      Button("Deal 3 More Cards") {
        setGameViewModel.askForMoreCards()
      }
      .padding(.horizontal, 4)
    }
    Text("Number of Cards in deck: \(setGameViewModel.deckCount)")
  }
}

#Preview {
  ContentView(setGameViewModel: SetGameViewModel(gameModel: SetGameModel()))
}
