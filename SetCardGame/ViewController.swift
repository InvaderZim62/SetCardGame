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
    let numberOfPlacesAvailable = 24
    var isMatchAvailable = true
    lazy var game = SetCardGame(numberOfCardsDealt: numberOfCardsDealt, numberOfPlacesAvailable: numberOfPlacesAvailable)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
//        for _ in 1...10 {
//            if let card = game.deck.drawRandom() {
//                print("\(card)")                    // example of good place to put debug code
//            }
//        }
    }

    @IBOutlet weak var moreCardsButton: UIButton! {
        didSet {
            moreCardsButton.layer.cornerRadius = 10
        }
    }
    
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
    
    @IBAction func select3MoreCards(_ sender: UIButton) {
        game.deal3MoreCards()
        updateViewFromModel()
    }
    
    @IBAction func selectNewGame(_ sender: UIButton) {
        game.reset()
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        _ = cardButtons.map { $0.isHidden = true }
        for index in game.cardsDealt.indices {
            let button = cardButtons[index]
            let card = game.cardsDealt[index]
            let visible = game.isCardVisible[index]
            let isSelected = game.isCardSelected[index]
            button.isHidden = false
            button.isEnabled = visible
            if visible {
                button.setAttributedTitle(symbolForCard(card: card), for: UIControlState.normal)
            } else {
                button.setAttributedTitle(nil, for: UIControlState.normal)
                button.setTitle(nil, for: UIControlState.normal)
            }
            button.layer.borderWidth = isSelected ? 3 : 1
            button.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            if isSelected {
                if let match = game.isMatchMade {
                    button.layer.backgroundColor = match ? #colorLiteral(red: 0.814127624, green: 0.9532099366, blue: 0.850346446, alpha: 1) : #colorLiteral(red: 0.9486960769, green: 0.7929092646, blue: 0.8161730766, alpha: 1)
                }
            }
        }
        moreCardsButton.layer.borderWidth = game.isMatchAvailable ? 0 : 2
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

