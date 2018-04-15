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
    let symbol: Symbol
    let shading: Shading
    let color: Color

    static let validRanks = [1, 2, 3]

    enum Symbol {
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
}
