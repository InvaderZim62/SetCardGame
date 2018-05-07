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
    // MARK: - Variables
    private struct Constants {
        static let initialNumberOfCardsDealt = 12
        static let buttonCornerRadius:CGFloat = 10
        static let cardAspectRatio:CGFloat = 0.7
        static let spaceBetweenCards:CGFloat = 0.04        // percentage of card width
    }
    private var isShowHint = false
    private var cardViews = [SetCardView]()
    private lazy var game = SetCardGame(numberOfCardsDealt: Constants.initialNumberOfCardsDealt)
    
    // MARK: - Outlets and Actions

    @IBOutlet weak var moreCardsButton: UIButton! {
        didSet {
            moreCardsButton.layer.cornerRadius = Constants.buttonCornerRadius
        }
    }
    

    @IBOutlet weak var newGameButton: UIButton! {
        didSet {
            newGameButton.layer.cornerRadius = Constants.buttonCornerRadius
        }
    }
    
    @IBOutlet weak var cardLayoutArea: UIView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(add3Cards))
            swipe.direction = .down
            cardLayoutArea.addGestureRecognizer(swipe)
        }
    }
    
    @IBAction func select3MoreCards(_ sender: UIButton) {
        add3Cards()
    }
    
    @objc private func add3Cards () {
        game.deal3MoreCards()
        isShowHint = false
        if cardViews.count > game.cardsDealt.count {         // check if cards were removed, instead of
            for index in game.selectedIndices.reversed() {   // replaced (due to no more cards in deck)
                cardViews[index].removeFromSuperview()
                cardViews.remove(at: index)
            }
        } else {
            addCardViews(count: game.cardsDealt.count - cardViews.count)
        }
        layoutSubviews()
        updateViewFromModel()
    }
    
    @IBAction func selectHint(_ sender: UIButton) {
        isShowHint = !isShowHint
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
    
    func addCardViews(count: Int) {         // cardViews created here and positioned in layoutSubviews
        for _ in 0..<count {
            let cardView = SetCardView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(tappedCard))
            tap.numberOfTapsRequired = 1
            cardView.addGestureRecognizer(tap)
            cardViews.append(cardView)
        }
    }
    
    @objc private func tappedCard(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let cardView = recognizer.view as? SetCardView, let index = cardViews.index(of: cardView) {
                game.cardSelected(at: index)
                if cardViews.count > game.cardsDealt.count {         // check if cards were removed, instead of
                    for index in game.selectedIndices.reversed() {   // replaced (due to no more cards in deck)
                        cardViews[index].removeFromSuperview()
                        cardViews.remove(at: index)
                    }
                    layoutSubviews()
                }
                updateViewFromModel()
            }
        default:
            break
        }
    }
    
    override func viewDidLayoutSubviews() {   // called whenever bounds change
        super.viewDidLayoutSubviews()
        self.layoutSubviews()
        updateViewFromModel()
    }
    
    private func layoutSubviews() {
        var grid = Grid(layout: .aspectRatio(Constants.cardAspectRatio), frame: cardLayoutArea.bounds)
        grid.cellCount = cardViews.count
        var count = 0
        for row in 0..<grid.dimensions.rowCount {
            for col in 0..<grid.dimensions.columnCount {
                if count < cardViews.count {
                    let view = cardViews[count]
                    if let gridFrame = grid[row,col] {
                        view.frame = gridFrame
                        let spaceBetweenCards = Constants.spaceBetweenCards * view.frame.size.width
                        view.frame = view.frame.insetBy(dx: spaceBetweenCards, dy: spaceBetweenCards);
                        cardLayoutArea.addSubview(view)      // This will replace the view (not add another copy), so
                        count += 1                           // don't worry about calling every time orientation changes
                    }
                }
            }
        }
    }
    
    private func updateViewFromModel() {
        for index in self.cardViews.indices {
            let cardView = cardViews[index]
            let card = game.cardsDealt[index]
            cardView.rank = card.rank
            cardView.symbol = card.symbolString
            cardView.shading = card.shadingString
            cardView.color = card.colorUIColor
            cardView.isSelected = game.isCardSelected[index]
            cardView.backColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            if let isMatch = game.isMatchMade {      // isMatch is nil until any 3 cards are selected
                if cardView.isSelected {
                    cardView.backColor = isMatch ? #colorLiteral(red: 0.814127624, green: 0.9532099366, blue: 0.850346446, alpha: 1) : #colorLiteral(red: 0.9486960769, green: 0.7929092646, blue: 0.8161730766, alpha: 1)
                    isShowHint = false
                }
            } else if isShowHint && game.potentialMatchIndices.contains(index) {
                cardView.backColor = #colorLiteral(red: 0.9995340705, green: 0.9458183468, blue: 0.7034410847, alpha: 1)
            }
        }
        moreCardsButton.layer.borderWidth = !game.isMatchAvailable && game.deck.cards.count > 0 ? 2 : 0
        newGameButton.layer.borderWidth = !game.isMatchAvailable && game.deck.cards.count == 0 ? 2 : 0
    }
    
    private func reset() {
        _ = cardViews.map { $0.removeFromSuperview() }
        cardViews.removeAll()
        addCardViews(count: Constants.initialNumberOfCardsDealt)
        layoutSubviews()
        isShowHint = false
        updateViewFromModel()
    }
}

// This is UI stuff (doesn't go in the model), so put in an extension to the model in ViewController
extension SetCard {
    var symbolString: String {      // computed property
        switch self.symbol {
        case .shape1:
            return "diamond"
        case .shape2:
            return "oval"
        case .shape3:
            return "squiggle"
        }
    }
    
    var shadingString: String {
        switch self.shading {
        case .style1:
            return "solid"
        case .style2:
            return "striped"
        case .style3:
            return "none"
        }
    }
    
    var colorUIColor: UIColor {
        switch self.color {
        case .one:
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .two:
            return #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case .three:
            return #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        }
    }
}
