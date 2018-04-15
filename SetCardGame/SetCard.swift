//
//  SetCard.swift
//  SetCardGame
//
//  Created by Phil Stern on 4/12/18.
//  Copyright © 2018 Phil Stern. All rights reserved.
//

import Foundation

struct SetCard
{
    let rank: Int
    static let validRanks = [1, 2, 3]

    enum Symbol {
        case Shape1
        case Shape2
        case Shape3
    }
    let symbol: Symbol
    static let validSymbols = [Symbol.Shape1, .Shape2, .Shape3]

    enum Shading {
        case Style1
        case Style2
        case Style3
    }
    let shading: Shading
    static let validShading = [Shading.Style1, .Style2, .Style3]

    enum Color {
        case One
        case Two
        case Three
    }
    let color: Color
    static let validColors = [Color.One, .Two, .Three]
}
