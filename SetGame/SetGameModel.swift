//
//  SetGameModel.swift
//  SetGame
//
//  Created by Yonatan Shiftan on 27/05/2025.
//

import Foundation

struct SetGameModel {
  private(set) var unmatchedCards: [Card] = []
  private(set) var selectedCardIds: Set<UUID> = []
  private(set) var matchedCards: [Card] = []
  private(set) var currentVisibleCardsNumber: Int = 0

  private let firstNumberOfVisibleCards: Int = 12

  var visibleCards : [Card] {
    get { return Array(unmatchedCards[0..<currentVisibleCardsNumber]) }
  }
  var deckCount : Int {
    get { return unmatchedCards.count - currentVisibleCardsNumber }
  }
  var deckCards : [Card] {
    get { return Array(unmatchedCards[currentVisibleCardsNumber...]) }
  }

  // types
  enum CardColor: String, CaseIterable {
    case red
    case green
    case purple
  }
  enum CardShape: String, CaseIterable {
    case diamond
    case squiggle
    case oval
  }
  enum CardFill: String, CaseIterable {
    case empty
    case solid
    case striped
  }

  struct Card : Identifiable, Equatable {
    var id = UUID() // Adding a unique identifier

    var alreadyMatched: Bool = false

    var shape: CardShape
    var cardColor: CardColor
    var fill: CardFill
    var numberOfShapes: Int
  }

  init() {
    self.reset()
  }

  mutating func reset() {
    unmatchedCards = initCards()
    selectedCardIds = []
    currentVisibleCardsNumber = 0
  }

  mutating func initFirstCards() {
    currentVisibleCardsNumber = firstNumberOfVisibleCards
  }

  // init functions
  private func initCards() -> [Card] {
    var cards: [Card] = []
    for shape in CardShape.allCases {
      for color in CardColor.allCases {
        for fill in CardFill.allCases {
          for numberOfShapes in 1...3 {
            cards.append(Card(shape: shape, cardColor: color, fill: fill, numberOfShapes: numberOfShapes))
          }
        }
      }
    }

    return cards//.shuffled()
  }

  mutating func selectCard(uuid: UUID) {
    guard selectedCardIds.count < 3 else { fatalError("can't choose more than 3 cards") }
    selectedCardIds.insert(uuid)
  }

  mutating func unselectCard(uuid: UUID) {
    guard selectedCardIds.contains(uuid) else { print("ERROR: Tried to unselect a card that was not selected"); return }
    selectedCardIds.remove(uuid)
  }

  mutating func shuffleVisibleCards() {
    unmatchedCards.shuffleFirst(currentVisibleCardsNumber)
  }

  func isSetWasChosen() -> Bool {
    return selectedCardIds.count == 3
  }

  func isValidSet() -> Bool {
    let selectedCards = unmatchedCards.filter { selectedCardIds.contains($0.id) }
    guard selectedCards.count == 3 else { return false }

    func allSameOrAllDifferent<T: Hashable>(_ values: [T]) -> Bool {
      guard !values.isEmpty else { return false }

      let allSame = values.dropFirst().allSatisfy { $0 == values[0] }
      let allDifferent = Set(values).count == values.count

      return allSame || allDifferent
    }

    return allSameOrAllDifferent(selectedCards.map { $0.shape }) &&
    allSameOrAllDifferent(selectedCards.map { $0.cardColor }) &&
    allSameOrAllDifferent(selectedCards.map { $0.fill }) &&
    allSameOrAllDifferent(selectedCards.map { $0.numberOfShapes })
  }

  mutating func askForMoreCards() {
    currentVisibleCardsNumber = min(currentVisibleCardsNumber + 3, unmatchedCards.count)
  }

  mutating func clearSelection() {
    selectedCardIds = []
  }

  mutating func removeValidChosenSet() {
    if isValidSet() {
      for id in selectedCardIds {
        matchedCards.append(unmatchedCards.first(where: { $0.id == id })!)
      }
      unmatchedCards.removeAll(where: { selectedCardIds.contains($0.id) })
      currentVisibleCardsNumber -= 3
      selectedCardIds.removeAll(keepingCapacity: true) // we have to remove all, since these ids were removed
    }
  }
}

extension Array {
    /// Shuffles the first `n` elements of the array, leaving the rest untouched.
    mutating func shuffleFirst(_ n: Int) {
        guard n > 1, n <= count else { return }
        for i in 0..<(n - 1) {
            let j = Int.random(in: i..<n)
            swapAt(i, j)
        }
    }
}

