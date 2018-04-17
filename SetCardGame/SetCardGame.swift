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
    var isMatchMade: Bool?
    var deck = SetCardDeck()
    var cardsDealt = [SetCard]()
    var isCardSelected = [Bool]()

    init(numberOfCardsDealt: Int) {
        self.numberOfCardsDealt = numberOfCardsDealt
        reset()
    }
    
    mutating func cardSelected(at index:Int) {
        if index < isCardSelected.count {                           // make sure index is within array
            isMatchMade = nil
            numberOfCardsSelected = isCardSelected.filter { $0 == true }.count
            if numberOfCardsSelected == 3 {
                isCardSelected = isCardSelected.map { _ in false }  // set all to false
                numberOfCardsSelected = 1
            }
            isCardSelected[index] = !isCardSelected[index]
            numberOfCardsSelected = isCardSelected.filter { $0 == true }.count
            if numberOfCardsSelected == 3 {
                isMatchMade = checkForMatch()
            }
        }
    }
    
    func checkForMatch() -> Bool {
        let indices = isCardSelected.indices.filter { isCardSelected[$0] == true }
        let selectedCards = indices.map { cardsDealt[$0] }
        assert(selectedCards.count == 3, "SetCardGame.checkForMatch(\(selectedCards.count)): there should be 3 selected cards, here")
        if selectedCards[0].rank == selectedCards[1].rank {     // placeholder, for now
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
