//
//  SetCardDeck.swift
//  SetCardGame
//
//  Created by Phil Stern on 4/12/18.
//  Copyright © 2018 Phil Stern. All rights reserved.
//

import Foundation

struct SetCardDeck
{
    private(set) var cards = [SetCard]()
    
    init() {
        for rank in SetCard.validRanks {
            for symbol in SetCard.Symbol.all {
                for shading in SetCard.Shading.all {
                    for color in SetCard.Color.all {
                        cards.append(SetCard(rank: rank, symbol: symbol, shading: shading, color: color))
                    }
                }
            }
        }
    }
    
    mutating func drawRandom() -> SetCard? {
        if cards.count > 0 {
            let card = cards.remove(at: cards.count.arc4random)
            return card
        } else {
            return nil
        }
    }
}

// extend int to return randome number from 0 to the int itself
// Note: extensions can add computed properties, but not stored properties or propertiy observers
extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(-self)))
        } else {
            return 0
        }
    }
}
