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
    var deck = SetCardDeck()
    var cardsDealt = [SetCard]()
    var cardsSelected = [Bool]()

    init(numberOfCardsDealt: Int) {
        self.numberOfCardsDealt = numberOfCardsDealt
        reset()
    }
    
    mutating func cardSelected(at index:Int) {
        if index < cardsSelected.count {
            cardsSelected[index] = !cardsSelected[index]
        }
    }
    
    mutating func reset() {
        deck.reset()
        cardsDealt.removeAll()
        cardsSelected.removeAll()
        for _ in 0..<numberOfCardsDealt {
            if let card = deck.drawRandom() {
                cardsDealt.append(card)
                cardsSelected.append(false)
            }
        }
    }
}
