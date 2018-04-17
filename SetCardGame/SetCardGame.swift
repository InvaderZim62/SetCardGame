//
//  SetCardGame.swift
//  SetCardGame
//
//  Created by Phil Stern on 4/12/18.
//  Copyright © 2018 Phil Stern. All rights reserved.
//

import Foundation

struct SetCardGame
{
    var numberOfCardsDealt: Int
    var numberOfCardsSelected = 0
    var isMatchMade: Bool?            // true if 3 selected and match, false if 3 selected and no match, else nil
    var isPreviousMatchMade = false   // true if 3 selected and match, else false
    var matchIndices = [Int]()
    var deck = SetCardDeck()
    var cardsDealt = [SetCard]()
    var isCardSelected = [Bool]()     // same size as cardsDealt

    init(numberOfCardsDealt: Int) {
        self.numberOfCardsDealt = numberOfCardsDealt
        reset()
    }
    
    mutating func cardSelected(at index:Int) {
        if index < isCardSelected.count {                           // make sure index is within array
            numberOfCardsSelected = isCardSelected.count(of: true)  // uses my extention, below
            if numberOfCardsSelected == 3 {                         // if selected a card while 3 are already selected
                isCardSelected = isCardSelected.map { _ in false }  // clear all selections
                if isPreviousMatchMade {
                    for matchIndex in matchIndices {                // replace matched cards with new cards
                        if let card = deck.drawRandom() {
                            cardsDealt[matchIndex] = card
                        }
                    }
                }
            }
            if !(isPreviousMatchMade && matchIndices.contains(index)) {
                isCardSelected[index] = !isCardSelected[index]      // select current card, unless it was part of the previous match
            }
            isMatchMade = nil
            numberOfCardsSelected = isCardSelected.count(of: true)
            isPreviousMatchMade = false
            if numberOfCardsSelected == 3 {
                matchIndices = isCardSelected.indices(of: true)
                let selectedCards = matchIndices.map { cardsDealt[$0] }
                isMatchMade = checkForMatching(cards: selectedCards)
                isPreviousMatchMade = isMatchMade!
            }
        }
    }
    
    func checkForMatching(cards: [SetCard]) -> Bool {
        assert(cards.count == 3, "SetCardGame.checkForMatch(\(cards.count)): there should be 3 selected cards, here")
        if cards[0].rank == cards[1].rank {     // placeholder, for now
            return true
        }
        return false
    }
    
    mutating func reset() {
        deck.reset()
        cardsDealt.removeAll()
        isCardSelected.removeAll()
        numberOfCardsSelected = 0
        for _ in 0..<numberOfCardsDealt {
            if let card = deck.drawRandom() {
                cardsDealt.append(card)
                isCardSelected.append(false)
            }
        }
    }
}

extension Array where Element: Equatable {
    func count(of element: Element) -> Int {
        return self.filter { $0 == element }.count
    }
    func indices(of element: Element) -> [Int] {
        return self.indices.filter { self[$0] == element }
    }
}

