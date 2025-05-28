//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Yonatan Shiftan on 27/05/2025.
//

import Foundation

enum ChosenSetNotificationState {
  case none
  case correct
  case incorrect
}

class SetGameViewModel : ObservableObject {
  @Published var gameModel: SetGameModel
  var chosenSetNotificationState: ChosenSetNotificationState {
    get {
      if gameModel.selectedCardIds.count == 3 {
        if gameModel.isSetWasChosen() {
          return .correct
        }
        else {
          return .incorrect
        }
      }
      else {
        return .none
      }
    }
  }

  init(gameModel: SetGameModel) {
    self.gameModel = gameModel
  }

  var deckCount: Int {
    return gameModel.deckCount
  }

  var visibleCards: [SetGameModel.Card] {
    get {
      return gameModel.visibleCards
    }
  }

  func handleCardPress(uuid: UUID) {
    let alreadySelected = gameModel.selectedCardIds.contains(uuid)
    if gameModel.selectedCardIds.count >= 3 {
      if chosenSetNotificationState == .correct {
        gameModel.removeSetAndReplaceIfPossible()
      }
      gameModel.clearSelection()
      if alreadySelected {
        return
      }
      // else, choose this card
    }

    if alreadySelected {
      gameModel.unselectCard(uuid: uuid)
    }
    else {
      gameModel.selectCard(uuid: uuid)
    }
  }

  func isCardSelected(card: SetGameModel.Card) -> Bool {
    return gameModel.selectedCardIds.contains(card.id)
  }

  func askForMoreCards() {
    if chosenSetNotificationState == .correct {
      gameModel.removeSetAndReplaceIfPossible()
    }
    else {
      gameModel.askForMoreCards()
    }
  }

  func newGame() {
    gameModel.reset()
  }
}
