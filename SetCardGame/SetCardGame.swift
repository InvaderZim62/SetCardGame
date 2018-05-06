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
    // MARK: - Variables
    private var initialNumberOfCardsDealt: Int
    private var isPreviousMatchMade = false          // true if 3 selected and matched, else false
    private(set) var isMatchMade: Bool?              // true if 3 selected and matched, false if 3 selected and no match, else nil
    private(set) var isMatchAvailable = true
    private(set) var selectedIndices = [Int]()          // indices of three selected and matched cards
    private(set) var potentialMatchIndices = [Int]() // indices of three unselected matched cards
    private(set) var deck = SetCardDeck()
    private(set) var cardsDealt = [SetCard]()
    private(set) var isCardSelected = [Bool]()       // keep the same size as cardsDealt

    // MARK: - Functions

    init(numberOfCardsDealt: Int) {
        self.initialNumberOfCardsDealt = numberOfCardsDealt
        reset()
    }
    
    private var numberOfCardsSelected: Int {
        return isCardSelected.count(of: true)    // .count is my extension, below
    }

    mutating func cardSelected(at index:Int) {
        if index < isCardSelected.count {                           // make sure index is within dealt cards
            if numberOfCardsSelected == 3 {                         // if selected a card while 3 are already selected
                isCardSelected = isCardSelected.map { _ in false }  // clear all selections
                if !(isPreviousMatchMade && selectedIndices.contains(index)) {
                    isCardSelected[index] = !isCardSelected[index]  // select current card, unless it was part of the previous match
                }
                if isPreviousMatchMade {
                    replaceMatchedCards()
                }
                checkIfMatchAvailable()
            } else {
                isCardSelected[index] = !isCardSelected[index]
            }
            isMatchMade = nil
            isPreviousMatchMade = false
            if numberOfCardsSelected == 3 {
                selectedIndices = isCardSelected.indices(of: true)            // .indices is my extention, below
                let selectedCards = selectedIndices.map { cardsDealt[$0] }
                isMatchMade = SetCard.checkFor3Matching(cards: selectedCards)
                isPreviousMatchMade = isMatchMade!
            }
        }
    }
    
    private mutating func replaceMatchedCards() {
        for matchIndex in selectedIndices.reversed() {
            if let card = deck.drawRandom() {
                cardsDealt[matchIndex] = card           // replace matched card with new card from deck
            } else {
                cardsDealt.remove(at: matchIndex)
                isCardSelected.remove(at: matchIndex)
            }
        }
    }
    
    mutating func deal3MoreCards() {
        isCardSelected = isCardSelected.map { _ in false }  // clear all selections
        if isPreviousMatchMade {
            replaceMatchedCards()
            isPreviousMatchMade = false
        } else {
            for _ in 0..<3 {
                if let card = deck.drawRandom() {
                    cardsDealt.append(card)
                    isCardSelected.append(false)
                }
            }
        }
        checkIfMatchAvailable()
    }
    
    private mutating func checkIfMatchAvailable() {
        isMatchAvailable = false
        potentialMatchIndices = []
        if cardsDealt.count == 0 { return }
        for i in 0..<cardsDealt.count-2 {
            for j in i+1..<cardsDealt.count-1 {
                for k in j+1..<cardsDealt.count {
                    let testCards = [cardsDealt[i], cardsDealt[j], cardsDealt[k]]
                    isMatchAvailable = SetCard.checkFor3Matching(cards: testCards)
                    if isMatchAvailable {
                        print("available match: \(i+1),\(j+1),\(k+1)")
                        potentialMatchIndices = [i, j, k]
                        return
                    }
                }
            }
        }
    }

    mutating func reset() {
        deck.reset()
        cardsDealt.removeAll()
        isCardSelected.removeAll()
        for _ in 0..<initialNumberOfCardsDealt {
            if let card = deck.drawRandom() {
                cardsDealt.append(card)
                isCardSelected.append(false)
            }
        }
        isMatchMade = nil
        checkIfMatchAvailable()
    }
}

// MARK: - Extensions

extension Array where Element: Equatable {
    func count(of element: Element) -> Int {
        return self.filter { $0 == element }.count
    }
    func indices(of element: Element) -> [Int] {
        return self.indices.filter { self[$0] == element }
    }
}

