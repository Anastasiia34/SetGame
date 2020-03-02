//
//  SetGame.swift
//  Set
//
//  Created by Анастасия Стрекалова on 25.11.2019.
//  Copyright © 2019 Анастасия Стрекалова. All rights reserved.
//

import Foundation

struct SetGame{
    
    var cards = [Card]()
    var cardsOnBoard = [Card]()
    var chosenCards = [Card]()
    var matchedCards = [Card]()
    var haveAMatch : Bool
    var lastCardOnBoardIndex = 11
    var newCards = [Card]()
    var score : Int
    var setsNum = 0
    
    mutating func reshuffleCards(){
        cardsOnBoard.shuffle()
    }
    
    mutating func chooseCard(at index: Int){
//        new
        newCards.removeAll()
//        new
        if chosenCards.count < 3 {
            if chosenCards.contains(cardsOnBoard[index]){
                let removeIndexFromChosenCards = chosenCards.firstIndex(of: cardsOnBoard[index])!
                chosenCards.remove(at: removeIndexFromChosenCards)
                score -= 1
            } else {
                chosenCards += [cardsOnBoard[index]]
                if chosenCards.count == 3 {
                    checkMatching()
                }
            }
        } else if chosenCards.count == 3 {
            var deselectCards = false
            if haveAMatch {
                if (chosenCards.contains(cardsOnBoard[index])){
                    deselectCards = true
                }
                if lastCardOnBoardIndex != 80 {
                    replaceCards()
                }
            }
            chosenCards.removeAll()
            if !deselectCards {
                chosenCards += [cardsOnBoard[index]]
            }
        }
    }
    
    mutating func replaceCards () {
        newCards = Array(cards[lastCardOnBoardIndex+1...lastCardOnBoardIndex+3])
        var index = 1
        for card in chosenCards {
            let matchedCard = cardsOnBoard.firstIndex(of: card)!
            cardsOnBoard[matchedCard] = cards[lastCardOnBoardIndex + index]
            index += 1
        }
        lastCardOnBoardIndex += 3
        haveAMatch = false
        newCards.removeAll()
    }
    
    mutating func checkMatching () {
        var cardsColors = [Int]()
        var cardsQuantities = [Int]()
        var cardsFillings = [Int]()
        var cardsSigns = [Int]()
        
        var resultArray = [Bool]()
        
        func allEqualOrDifferent (feature : [Int]) {
            if feature[0] == feature[1] && feature[1] == feature[2] || feature[0] != feature[1] && feature[1] != feature[2] && feature[0] != feature[2]{
                resultArray += [true]
            } else {
                resultArray += [false]
            }
        }
        
        for index in chosenCards.indices {
            cardsColors += [chosenCards[index].color]
            cardsQuantities += [chosenCards[index].quantity]
            cardsFillings += [chosenCards[index].filling]
            cardsSigns += [chosenCards[index].sign]
        }
        
        allEqualOrDifferent(feature: cardsColors)
        allEqualOrDifferent(feature: cardsQuantities)
        allEqualOrDifferent(feature: cardsFillings)
        allEqualOrDifferent(feature: cardsSigns)
        
        if !resultArray.contains(false){
            matchedCards += chosenCards
            haveAMatch = true
            score += 3
            setsNum += 1
        } else {
//            score -= 5
            matchedCards += chosenCards
            haveAMatch = true
            score += 3
            setsNum += 1
        }
    }
    
    mutating func dealThreeMoreCards () {
        if haveAMatch && lastCardOnBoardIndex != 80 {
            replaceCards()
            chosenCards.removeAll()
        } else {
            newCards = Array(cards[lastCardOnBoardIndex+1...lastCardOnBoardIndex+3])
            cardsOnBoard += newCards
            lastCardOnBoardIndex += 3
        }
    }
        
    init(){
        Card.identifierFactory = -1
        
        chosenCards = [Card]()
        matchedCards = [Card]()
        haveAMatch = false
        lastCardOnBoardIndex = 11
        score = 0
        
        for _ in 1...81{
            let card = Card()
            cards += [card]
        }
        
        var emptyArray = [Card]()
        
        for _ in cards{
            let randomIndex = (cards.count - 1).arc4random
            emptyArray.append(cards[randomIndex])
            cards.remove(at: randomIndex)
        }
        
        cards = emptyArray
        
        for index in cards.indices {
            if index < 12 {
                cardsOnBoard += [cards[index]]
            }
        }
    }
    
}
