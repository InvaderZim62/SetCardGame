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
    var cards = [SetCard]()
    
    init() {
        for rank in SetCard.validRanks {
            for symbol in SetCard.validSymbols {
                for shading in SetCard.validShading {
                    for color in SetCard.validColors {
                        let card = SetCard(rank: rank, symbol: symbol, shading: shading, color: color)
                        cards += [card]
                    }
                }
            }
        }
    }
}
