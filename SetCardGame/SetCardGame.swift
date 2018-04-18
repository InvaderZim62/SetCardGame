//
//  SetCardGame.swift
//  SetCardGame
//
//  Created by Phil Stern on 4/12/18.
//  Copyright © 2018 Phil Stern. All rights reserved.
//

import Foundation

struct SetCardGame
{
    var numberOfCardsDealt: Int
    var numberOfPlacesAvailable: Int
    var numberOfCardsSelected = 0
    var isMatchMade: Bool?            // true if 3 selected and match, false if 3 selected and no match, else nil
    var isPreviousMatchMade = false   // true if 3 selected and match, else false
    var isMatchAvailable = true
    var matchIndices = [Int]()
    var deck = SetCardDeck()
    var cardsDealt = [SetCard]()
    var isCardSelected = [Bool]()     // same size as cardsDealt
    var isCardVisible = [Bool]()      // same size as cardsDealt
    var gameOver = false

    init(numberOfCardsDealt: Int, numberOfPlacesAvailable: Int) {
        self.numberOfCardsDealt = numberOfCardsDealt
        self.numberOfPlacesAvailable = numberOfPlacesAvailable
        reset()
    }
    
    mutating func cardSelected(at index:Int) {
        if index < isCardSelected.count {                           // make sure index is within dealt cards
            numberOfCardsSelected = isCardSelected.count(of: true)  // uses an extention, below
            if numberOfCardsSelected == 3 {                         // if selected a card while 3 are already selected
                isCardSelected = isCardSelected.map { _ in false }  // clear all selections
                if isPreviousMatchMade {
                    replaceMatchedCards()
                }
                checkIfMatchAvailable()
            }
            if !(isPreviousMatchMade && matchIndices.contains(index)) {
                isCardSelected[index] = !isCardSelected[index]      // select current card, unless it was part of the previous match
            }
            isMatchMade = nil
            numberOfCardsSelected = isCardSelected.count(of: true)
            isPreviousMatchMade = false
            if numberOfCardsSelected == 3 {
                matchIndices = isCardSelected.indices(of: true)
                let selectedCards = matchIndices.map { cardsDealt[$0] }
                isMatchMade = SetCard.checkFor3Matching(cards: selectedCards)
                isPreviousMatchMade = isMatchMade!
            }
        }
    }
    
    mutating func replaceMatchedCards () {
        for matchIndex in matchIndices {
            if let card = deck.drawRandom() {
                cardsDealt[matchIndex] = card           // replace matched card with new card from deck
            } else {
                isCardVisible[matchIndex] = false       // hide matched card, since deck is empty
                if isCardVisible.count(of: true) == 0 { gameOver = true }
            }
        }
    }
    
    mutating func deal3MoreCards() {
        isCardSelected = isCardSelected.map { _ in false }  // clear all selections
        if isPreviousMatchMade {
            replaceMatchedCards()
            isPreviousMatchMade = false
        } else if cardsDealt.count <= numberOfPlacesAvailable - 3 {
            for _ in 0..<3 {
                if let card = deck.drawRandom() {
                    cardsDealt.append(card)
                    isCardSelected.append(false)
                    isCardVisible.append(true)
                }
            }
        }
        checkIfMatchAvailable()
    }
    
    mutating func checkIfMatchAvailable() {
        isMatchAvailable = false
        for i in 0..<cardsDealt.count-2 {
            if isCardVisible[i] {
                for j in i+1..<cardsDealt.count-1 {
                    if isCardVisible[j] {
                        for k in j+1..<cardsDealt.count {
                            if isCardVisible[k] {
                                let testCards = [cardsDealt[i], cardsDealt[j], cardsDealt[k]]
                                isMatchAvailable = SetCard.checkFor3Matching(cards: testCards)
                                if isMatchAvailable {
                                    print("available match: \(i),\(j),\(k)")
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    mutating func reset() {
        gameOver = false
        deck.reset()
        cardsDealt.removeAll()
        isCardSelected.removeAll()
        isCardVisible.removeAll()
        numberOfCardsSelected = 0
        for _ in 0..<numberOfCardsDealt {
            if let card = deck.drawRandom() {
                cardsDealt.append(card)
                isCardSelected.append(false)
                isCardVisible.append(true)
            }
        }
        checkIfMatchAvailable()
    }
}

extension Array where Element: Equatable {
    func count(of element: Element) -> Int {
        return self.filter { $0 == element }.count
    }
    func indices(of element: Element) -> [Int] {
        return self.indices.filter { self[$0] == element }
    }
}

