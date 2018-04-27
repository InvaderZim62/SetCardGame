//
//  ViewController.swift
//  SetCardGame
//
//  Created by Phil Stern on 4/12/18.
//  Copyright © 2018 Phil Stern. All rights reserved.
//
//  To hide strange xcode logs when running the simulator
//  (ex. "Lazy loading NSBundle MobileCoreServices.framework")
//  I did the following:
//    Select: Product (top menu) > Scheme > Edit Scheme...
//    In Environment Variables, set OS_ACTIVITY_MODE = disable

import UIKit

class ViewController: UIViewController
{
    // MARK: - Variables
    private struct Constants {
        static let initialNumberOfCardsDealt = 12
        static let numberOfPlacesAvailable = 24
    }
    private var isMatchAvailable = true
    private var cardViews = [SetCardView]()
    private lazy var game = SetCardGame(numberOfCardsDealt: Constants.initialNumberOfCardsDealt,
                                        numberOfPlacesAvailable: Constants.numberOfPlacesAvailable)
    
    // MARK: - Outlets and Actions

    @IBOutlet weak var moreCardsButton: UIButton! {
        didSet {
            moreCardsButton.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var newGameButton: UIButton! {
        didSet {
            newGameButton.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var cardLayoutArea: UIView!
    
    @IBAction func select3MoreCards(_ sender: UIButton) {
        game.deal3MoreCards()
        addCardViews(count: game.cardsDealt.count - cardViews.count)
        layoutSubviews()
        updateViewFromModel()
    }
    
    @IBAction func selectNewGame(_ sender: UIButton) {
        game.reset()
        self.reset()
        updateViewFromModel()
    }
    
    // MARK: - Functions

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addCardViews(count: Constants.initialNumberOfCardsDealt)
        updateViewFromModel()
    }
    
    func addCardViews(count: Int) {
        for _ in 0..<count {
            let cardView = SetCardView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(tappedCard))
            tap.numberOfTapsRequired = 1
            cardView.addGestureRecognizer(tap)
            cardViews.append(cardView)
        }
    }
    
    @objc func tappedCard(sender: UITapGestureRecognizer) {
        let cardView = sender.view as! SetCardView
        if let index = cardViews.index(of: cardView) {
            game.cardSelected(at: index)
            updateViewFromModel()
        }
    }
    
    override func viewDidLayoutSubviews() {   // called whenever bounds change
        super.viewDidLayoutSubviews()
        self.layoutSubviews()
        updateViewFromModel()
    }
    
    private func layoutSubviews() {
        let cardWidth = 62.0
        let cardHeight = 80.0
        let layoutHeight = Double(cardLayoutArea.bounds.height)
        let layoutWidth = Double(cardLayoutArea.bounds.width)
        var count = 0
        for j in stride(from: 0.0, to: layoutHeight - cardHeight, by: cardHeight + 5.0) {
            for i in stride(from: 0.0, to: layoutWidth - cardWidth, by: cardWidth + 5.0) {
                if count < cardViews.count {
                    let view = cardViews[count]
                    view.frame = CGRect(x: i, y: j, width: cardWidth, height: cardHeight)
                    cardLayoutArea.addSubview(view)
                    count += 1
                }
            }
        }
    }
    
    private func updateViewFromModel() {
        for cardView in self.cardViews {
            if let cardViewIndex = cardViews.index(of: cardView) {
                let setCard = game.cardsDealt[cardViewIndex]
                cardView.rank = setCard.rank
                cardView.symbol = symbolForCard(card: setCard)
                cardView.color = colorForCard(card: setCard)
                cardView.shading = shadingForCard(card: setCard)
                cardView.isVisible = game.isCardVisible[cardViewIndex]
                cardView.backColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                let isSelected = game.isCardSelected[cardViewIndex]
                cardView.isSelected = isSelected
                if isSelected {
                    if let isMatch = game.isMatchMade {
                        cardView.backColor = isMatch ? #colorLiteral(red: 0.814127624, green: 0.9532099366, blue: 0.850346446, alpha: 1) : #colorLiteral(red: 0.9486960769, green: 0.7929092646, blue: 0.8161730766, alpha: 1)
                    }
                }
            }
        }
        moreCardsButton.layer.borderWidth = !game.isMatchAvailable && game.deck.cards.count > 0 ? 2 : 0
        newGameButton.layer.borderWidth = !game.isMatchAvailable && game.deck.cards.count == 0 ? 2 : 0
    }
    
    private func symbolForCard(card: SetCard) -> String {
        var symbol: String
        switch card.symbol {
        case .shape1:
            symbol = "diamond"
        case .shape2:
            symbol = "oval"
        case .shape3:
            symbol = "squiggle"
        }
        return symbol
    }
    
    private func shadingForCard(card: SetCard) -> String {
        var shading: String
        switch card.shading {
        case .style1:
            shading = "solid"
        case .style2:
            shading = "striped"
        case .style3:
            shading = "none"
        }
        return shading
    }

    private func colorForCard(card: SetCard) -> UIColor {
        var color: UIColor
        switch card.color {
        case .one:
            color = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .two:
            color = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case .three:
            color = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        }
        return color
    }
    
    private func reset() {
        _ = cardViews.map { $0.removeFromSuperview() }
        cardViews.removeAll()
        addCardViews(count: Constants.initialNumberOfCardsDealt)
        viewDidLayoutSubviews()
    }
}

