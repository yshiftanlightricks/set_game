//
//  SetGameModel.swift
//  SetGame
//
//  Created by Yonatan Shiftan on 27/05/2025.
//

import Foundation

struct SetGameModel {
  private(set) var cards: [Card] = []
  private(set) var selectedCardIds: Set<UUID> = []
  private(set) var currentVisibleCardsNumber: Int = 0

  private let firstNumberOfVisibleCards: Int = 12

  var visibleCards : [Card] {
    get { return Array(cards[0..<currentVisibleCardsNumber]) }
  }
  var deckCount : Int {
    get { return cards.count  - currentVisibleCardsNumber }
  }

  // types
  enum CardColor: String, CaseIterable {
    case red
    case green
    case yellow
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
    var color: CardColor
    var fill: CardFill
    var numberOfShapes: Int
  }

  init() {
    self.reset()
  }

  mutating func reset() {
    cards = initCards()
    selectedCardIds = []
    currentVisibleCardsNumber = firstNumberOfVisibleCards
  }

  // init functions
  func initCards() -> [Card] {
    var cards: [Card] = []
    for shape in CardShape.allCases {
      for color in CardColor.allCases {
        for fill in CardFill.allCases {
          for numberOfShapes in 1...3 {
            cards.append(Card(shape: shape, color: color, fill: fill, numberOfShapes: numberOfShapes))
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

  func isSetWasChosen() -> Bool {
    return selectedCardIds.count == 3
  }

  func isValidSet() -> Bool {
    let selectedCards = cards.filter { selectedCardIds.contains($0.id) }
    guard selectedCards.count == 3 else { return false }

    func allSameOrAllDifferent<T: Hashable>(_ values: [T]) -> Bool {
      guard !values.isEmpty else { return false }

      let allSame = values.dropFirst().allSatisfy { $0 == values[0] }
      let allDifferent = Set(values).count == values.count

      return allSame || allDifferent
    }

    return allSameOrAllDifferent(selectedCards.map { $0.shape }) &&
    allSameOrAllDifferent(selectedCards.map { $0.color }) &&
    allSameOrAllDifferent(selectedCards.map { $0.fill }) &&
    allSameOrAllDifferent(selectedCards.map { $0.numberOfShapes })
  }

  mutating func askForMoreCards() {
    currentVisibleCardsNumber = (currentVisibleCardsNumber + 3) % cards.count
    // TODO:///
  }

  mutating func clearSelection() {
    selectedCardIds = []
  }

  mutating func removeSetAndReplaceIfPossible() {
    if isValidSet() {
      if cards.count >= currentVisibleCardsNumber + 3 {
        selectedCardIds.forEach { id in
          let idx = cards.firstIndex(of: cards.first(where: { $0.id == id })!)!
          cards[idx] = cards[cards.count - 1]
          cards.removeLast()
        }
      }
      else {
        cards.removeAll(where: { selectedCardIds.contains($0.id) })
      }
    }
  }
}
