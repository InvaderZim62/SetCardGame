//
//  SetCard.swift
//  SetCardGame
//
//  Created by Phil Stern on 4/12/18.
//  Copyright © 2018 Phil Stern. All rights reserved.
//

import Foundation

struct SetCard: CustomStringConvertible  // CustomStringConvertable protocol allows custom output for print (requies "var description")
{
    // MARK: - Variables
    var description: String { return "rank:\(rank) \(symbol) shading:\(shading) color:\(color)" }
    let rank: Int
    let symbol: Symbol
    let shading: Shading
    let color: Color

    static let validRanks = [1, 2, 3]

    enum Symbol: String, CustomStringConvertible {                // each enum can have it's own description
        var description: String { return "symbol:\(rawValue)" }
        
        case shape1
        case shape2
        case shape3
        
        static let all = [Symbol.shape1, .shape2, .shape3]
    }

    enum Shading {
        case style1
        case style2
        case style3
        
        static let all = [Shading.style1, .style2, .style3]
    }

    enum Color {
        case one
        case two
        case three
        
        static let all = [Color.one, .two, .three]
    }
    
    // MARK: - Functions

    static func checkFor3Matching(cards: [SetCard]) -> Bool {
        assert(cards.count == 3, "SetCardGame.checkForMatch(\(cards.count)): there should be 3 selected cards, here")
        
        //return true  // for debugging, to make everything match, uncomment this line
        
        var matchCount = 0
        
        if cards[0].rank == cards[1].rank &&
           cards[1].rank == cards[2].rank { matchCount += 1 }
        if cards[0].rank != cards[1].rank &&
           cards[1].rank != cards[2].rank &&
           cards[2].rank != cards[0].rank { matchCount += 1 }

        if cards[0].symbol == cards[1].symbol &&
           cards[1].symbol == cards[2].symbol { matchCount += 1 }
        if cards[0].symbol != cards[1].symbol &&
           cards[1].symbol != cards[2].symbol &&
           cards[2].symbol != cards[0].symbol { matchCount += 1 }
        
        if cards[0].shading == cards[1].shading &&
           cards[1].shading == cards[2].shading { matchCount += 1 }
        if cards[0].shading != cards[1].shading &&
           cards[1].shading != cards[2].shading &&
           cards[2].shading != cards[0].shading { matchCount += 1 }

        if cards[0].color == cards[1].color &&
           cards[1].color == cards[2].color { matchCount += 1 }
        if cards[0].color != cards[1].color &&
           cards[1].color != cards[2].color &&
           cards[2].color != cards[0].color { matchCount += 1 }

        if matchCount == 4 {
            return true
        } else {
            return false
        }
    }
}
