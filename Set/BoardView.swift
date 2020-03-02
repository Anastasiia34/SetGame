//
//  DeckView.swift
//  Set
//
//  Created by Анастасия Стрекалова on 17.01.2020.
//  Copyright © 2020 Анастасия Стрекалова. All rights reserved.
//

import UIKit

@IBDesignable
class BoardView: UIView {

    var cardViews = [CardView]() {
        willSet { removeSubviews(); layoutIfNeeded() }
        didSet { addSubviews(); layoutIfNeeded() }
    }
    
    private func removeSubviews() {
        for card in cardViews {
            card.removeFromSuperview()
        }
    }
 
    private func addSubviews() {
        for card in cardViews {
            addSubview(card)
        }
    }
    
    var copyCardViews = [CardView]() {
        didSet { addCopySubviews(); layoutIfNeeded() }
    }
    
    private func addCopySubviews() {
        for card in copyCardViews {
            addSubview(card)
        }
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        var grid = Grid(layout: Grid.Layout.aspectRatio(Constant.cellAspectRatio), frame: bounds)
        let notHiddenCards = cardViews.filter { !$0.isHidden }
        grid.cellCount = notHiddenCards.count
        for row in 0..<grid.dimensions.rowCount {
            for column in 0..<grid.dimensions.columnCount {
                if notHiddenCards.count > (row * grid.dimensions.columnCount + column) {
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 1,
                        delay: TimeInterval(row)*0.1,
                        options: [.curveEaseInOut],
                        animations: { notHiddenCards[row * grid.dimensions.columnCount + column].frame = grid[row, column]!.insetBy(dx: Constant.spacingDx, dy: Constant.spacingDy) }
                    )
                    notHiddenCards[row * grid.dimensions.columnCount + column].cardViewCenter = notHiddenCards[row * grid.dimensions.columnCount + column].center
                }
            }
        }
    }
}

struct Constant{
    static let cellAspectRatio: CGFloat = 0.7
    static let spacingDx: CGFloat = 2.0
    static let spacingDy: CGFloat = 2.0
}
