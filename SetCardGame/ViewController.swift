//
//  ViewController.swift
//  SetCardGame
//
//  Created by Phil Stern on 4/12/18.
//  Copyright © 2018 Phil Stern. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var game = SetCardGame(numberOfCardsDealt: 12)

    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
    }
    
    @IBAction func selectMoreCards(_ sender: UIButton) {
    }
    
    @IBAction func selectNewGame(_ sender: UIButton) {
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            if index < 12 {
                let card = game.cardsDealt[index]
                button.setAttributedTitle(symbolForCard(card: card), for: UIControlState.normal)
            }
        }
    }
    
    func symbolForCard(card: SetCard) -> NSAttributedString {
        var symbol: String
        switch card.symbol {
        case .Shape1:
            symbol = "▲"
        case .Shape2:
            symbol = "●"
        case .Shape3:
            symbol = "■"
        }
        
        var shading: CGFloat
        switch card.shading {
        case .Style1:
            shading = 0.0
        case .Style2:
            shading = 0.15
        case .Style3:
            shading = 1.0
        }

        var color: UIColor
        switch card.color {
        case .One:
            color = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .Two:
            color = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case .Three:
            color = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        }

        let cardTitleString = String(repeating: symbol, count: card.rank)
        
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeColor: color,
            .strokeWidth: -5,
            .foregroundColor : color.withAlphaComponent(shading)
        ]
        
        return NSAttributedString(string: cardTitleString, attributes: attributes)
    }
}

