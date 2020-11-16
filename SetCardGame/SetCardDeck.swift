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
    // MARK: - Variables
    private(set) var cards = [SetCard]()  // cards are in order, but drawn randomly (removed from array)
    
    // MARK: - Functions
    
    init() {
        reset()
    }
    
    mutating func reset() {
        cards.removeAll()
        for rank in SetCard.validRanks {
            for symbol in SetCard.Symbol.all {
                for shading in SetCard.Shading.all {
                    if GameMods.useFullDeck {
                        for color in SetCard.Color.all {
                            cards.append(SetCard(rank: rank, symbol: symbol, shading: shading, color: color))
                        }
                    } else {
                        cards.append(SetCard(rank: rank, symbol: symbol, shading: shading, color: SetCard.Color.one))
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

// MARK: - Extensions

extension Int {
    // return random number from 0 to the Int itself (exclusive)
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
