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
    var deck = SetCardDeck()
    var cardsDealt = [SetCard]()

    init(numberOfCardsDealt: Int) {
        for _ in 0..<numberOfCardsDealt {
            if let card = deck.drawRandom() {
                cardsDealt += [card]
            }
        }
    }
}
