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
    let numberOfCardsDealt = 12
    lazy var game = SetCardGame(numberOfCardsDealt: numberOfCardsDealt)
    
//    override func viewDidLoad() {        // eample of good place to put debug code
//        super.viewDidLoad()
//        for _ in 1...10 {
//            if let card = game.deck.drawRandom() {
//                print("\(card)")
//            }
//        }
//    }

    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            _ = cardButtons.map { $0.layer.cornerRadius = 10 }
            _ = cardButtons.map { $0.layer.borderWidth = 1 }
        }
    }

    @IBAction func touchCard(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender) {
            game.cardSelected(at: index)
        } else {
            print("Selected button not found in cardButtons")
        }
        updateViewFromModel()
    }
    
    @IBAction func selectMoreCards(_ sender: UIButton) {
    }
    
    @IBAction func selectNewGame(_ sender: UIButton) {
        game.reset()
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in game.cardsDealt.indices {
            let button = cardButtons[index]
            let card = game.cardsDealt[index]
            let isSelected = game.cardsSelected[index]
            button.setAttributedTitle(symbolForCard(card: card), for: UIControlState.normal)
            button.layer.borderWidth = isSelected ? 3 : 1
        }
    }
    
    func symbolForCard(card: SetCard) -> NSAttributedString {
        var symbol: String
        switch card.symbol {
        case .shape1:
            symbol = "▲"
        case .shape2:
            symbol = "●"
        case .shape3:
            symbol = "■"
        }
        
        var shading: CGFloat
        switch card.shading {
        case .style1:
            shading = 0.0
        case .style2:
            shading = 0.15
        case .style3:
            shading = 1.0
        }

        var color: UIColor
        switch card.color {
        case .one:
            color = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .two:
            color = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case .three:
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

