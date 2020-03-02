//
//  ViewController.swift
//  Set
//
//  Created by Анастасия Стрекалова on 25.11.2019.
//  Copyright © 2019 Анастасия Стрекалова. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var animator = UIDynamicAnimator(referenceView: boardView)
    
    lazy var flyAwayBehavior = FlyAwayBehavior(in: animator)
    
    //    lazy var cardBehavior = CardBehavior(in: animator)
    
    var game = SetGame()
    
    @IBOutlet weak var boardView: BoardView!
    
    private var tmpCards = [CardView]()
    
    @IBOutlet var deal: UILabel! {
        didSet {
            deal.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dealThreeMoreCards(_:)))
            deal.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    var dealCenter = CGPoint()
    
    @IBOutlet var setsLabel: UILabel!
    lazy var discardPileCenter = self.view.convert(self.setsLabel.center, to: self.boardView)
    
    override func viewDidLoad() {
        dealCenter = view.convert(deal.center, to: boardView)
        super.viewDidLoad()
        for index in game.cards.indices {
            boardView.cardViews.append(CardView())
            if !game.cardsOnBoard.contains(game.cards[index]) {
                boardView.cardViews[index].isHidden = true
            }
        }
//        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dealThreeMoreCards(_:)))
//        swipe.direction = .down
//        view.addGestureRecognizer(swipe)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(reshuffleCards(byHandlingGestureRecognizedBy:)))
        view.addGestureRecognizer(rotation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        var delay = 0.0
        for index in game.cardsOnBoard.indices {
            updateCardViewsFromModel(for: index)
            boardView.cardViews[index].deal(from: dealCenter, withBounds: deal.bounds, withDelay: delay)
            delay += 0.3
        }
        self.updateViewFromModel()
    }
    
    @objc func reshuffleCards(byHandlingGestureRecognizedBy recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .ended: game.reshuffleCards(); updateViewFromModel()
        default: break
        }
    }
    
    @objc private func chooseCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let cardView = recognizer.view! as? CardView {
                game.chooseCard(at: boardView.cardViews.firstIndex(of: cardView)!)
                updateViewFromModel()
            }
        default: break
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame()
        boardView.cardViews.removeAll()
        viewDidLoad()
    }
    
    //    @IBOutlet weak var scoreLabel: UILabel!
    
    private func updateViewFromModel() {
        setsLabel.text = "\(game.setsNum) Sets"
        var dealThreeCards = false
        var matchedCardViewsIndicies = [Int]()
        matchedCardViewsIndicies.removeAll()
        var delay = 0.0
        for index in game.cardsOnBoard.indices {
            let cardView = boardView.cardViews[index]
            let card = game.cardsOnBoard[index]
            cardView.isHidden = false
            if !game.cardsOnBoard.contains(card){
                cardView.isHidden = true
            }
            updateCardViewsFromModel(for: index)
            if game.chosenCards.contains(card) {
                cardView.isSelected = true
            } else {
                cardView.isSelected = false
            }
            if game.chosenCards.count == 3 && game.chosenCards.contains(card) {
                if game.matchedCards.contains(card){
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.2,
                        delay: 0,
                        options: [],
                        animations: { cardView.alpha = 0 },
                        completion: { position in
                                cardView.alpha = 1
                                cardView.deal(from: self.dealCenter, withBounds: self.deal.bounds, withDelay: delay)
                            delay += 0.3
                    }
                    )
                    tmpCards.append(cardView.copyCard())
                    dealThreeCards = true
                } else {
                    cardView.isMatched = false
                }
            } else {
                cardView.isMatched = nil
            }
            if game.lastCardOnBoardIndex == 80 &&
                game.matchedCards.contains(card){
                cardView.isHidden = true
                boardView.layoutSubviews()
            }
        }
        
        delay = 0.0
        if dealThreeCards {
            self.game.dealThreeMoreCards()
            self.updateViewFromModel()
            dealThreeCards = false
        }
//        deals new cards from deck
        for newCard in game.newCards {
            let newCardIndex = game.cardsOnBoard.firstIndex(of: newCard)!
            boardView.cardViews[newCardIndex].deal(from: dealCenter, withBounds: deal.bounds, withDelay: delay)
            delay += 0.3
        }
        
        //        let score = game.score
        
//        disables deal at the end of the game
        if game.lastCardOnBoardIndex == 80 {
            deal.isUserInteractionEnabled = false
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [], animations: { self.deal.alpha = 0 })
        }
        
//        animates cards' copies
        tmpCards.forEach { tmpCard in
            boardView.copyCardViews.append(tmpCard)
            flyAwayBehavior.addItem(tmpCard)
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {_ in
                self.flyAwayBehavior.removeItem(tmpCard)
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 1,
                    delay: 0,
                    options: [],
                    animations: {
                        tmpCard.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi/2)
                        tmpCard.frame.size.width = self.deal.bounds.width
                        tmpCard.frame.size.height = self.deal.bounds.height
                        tmpCard.center = self.discardPileCenter
                },
                    completion: { position in
                        UIView.transition(
                            with: tmpCard,
                            duration: 1,
                            options: [ .transitionFlipFromLeft ],
                            animations: { tmpCard.isFaceUp = !tmpCard.isFaceUp }
                        )
                }
                )
            })
        }
        tmpCards.removeAll()

        //        scoreLabel.text = "score: \(score)"
        
        boardView.layoutSubviews()
    }
    
    private func updateCardViewsFromModel(for index: Int) {
        
        let card = game.cardsOnBoard[index]
        let cardView = boardView.cardViews[index]
        
        cardView.signInt = card.sign
        cardView.colorsInt = card.color
        cardView.fillInt = card.filling
        cardView.quantity = card.quantity
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseCard(_:)))
        cardView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private var sign = [Int:NSAttributedString]()
    
    //    @IBOutlet weak var dealThreeMoreCardsButton: UIButton!
    
    @objc func dealThreeMoreCards(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            game.dealThreeMoreCards()
            updateViewFromModel()
        default: break
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        if self > 0 {
            return CGFloat(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -CGFloat(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
