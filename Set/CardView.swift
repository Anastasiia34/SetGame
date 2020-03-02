//
//  CardView.swift
//  Set
//
//  Created by Анастасия Стрекалова on 17.01.2020.
//  Copyright © 2020 Анастасия Стрекалова. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {

    @IBInspectable
    var isFaceUp: Bool = false{
        didSet{ setNeedsDisplay(); setNeedsLayout() }
    }
    @IBInspectable
    var isSelected: Bool = false {
        didSet{ setNeedsDisplay(); setNeedsLayout() }
    }
    var isMatched: Bool? {
        didSet{ setNeedsDisplay(); setNeedsLayout() }
    }
    
    private var color = Colors.red {
        didSet{ setNeedsDisplay(); setNeedsLayout() }
    }
    private var sign = Sign.diamond {
        didSet{ setNeedsDisplay(); setNeedsLayout() }
    }
    private var fill = Fill.solid {
        didSet{ setNeedsDisplay(); setNeedsLayout() }
    }
    @IBInspectable
    var quantity: Int = 1 {
        didSet{ setNeedsDisplay(); setNeedsLayout() }
    }
    
    private struct Colors {
        static let green = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        static let red = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        static let purple = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        static let blue = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    }
    private enum Sign {
        case squiggle
        case diamond
        case oval
    }
    private enum Fill {
        case solid
        case striped
        case unfilled
    }
    
    //vars for public API
    @IBInspectable
    var colorsInt: Int = 1 {
        didSet {
            switch colorsInt {
            case 1: color = Colors.green
            case 2: color = Colors.red
            case 3: color = Colors.purple
            default:
                break
            }
        }
    }
    @IBInspectable
    var signInt: Int = 1 {
        didSet{
            switch signInt {
            case 1: sign = Sign.squiggle
            case 2: sign = Sign.diamond
            case 3: sign = Sign.oval
            default: break
            }
        }
    }
    @IBInspectable
    var fillInt: Int = 1 {
        didSet{
            switch fillInt {
            case 1: fill = Fill.solid
            case 2: fill = Fill.striped
            case 3: fill = Fill.unfilled
            default: break
            }
        }
    }
    
    var cardViewCenter = CGPoint()
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        if isFaceUp{
            UIColor.white.setFill()
            roundedRect.fill()
            drawSigns()
            if isSelected {
                Colors.blue.setStroke()
                roundedRect.lineWidth = 5.0
                roundedRect.stroke()
            }
            if isMatched != nil {
                if isMatched! {
                    Colors.green.setStroke()
                } else {
                    Colors.red.setStroke()
                }
                roundedRect.lineWidth = 5.0
                roundedRect.stroke()
            }
        } else {
            UIColor.systemBlue.setFill()
            roundedRect.fill()
        }
        
    }
    
    private func drawSigns() {
        color.setFill()
        color.setStroke()
        
        let size = CGSize(width: faceFrame.width, height: signHeight)
        let origin = CGPoint(x: faceFrame.minX, y: (faceFrame.midY - signHeight/2))
        let signRect = CGRect(origin: origin, size: size)
        
        switch quantity {
        case 1: drawShape(in: signRect)
        case 2:
            let firstSignRect = signRect.offsetBy(dx: 0, dy: -signHeight/2-interSignHeight)
            let secondSignRect = signRect.offsetBy(dx: 0, dy: signHeight/2+interSignHeight)
            drawShape(in: firstSignRect)
            drawShape(in: secondSignRect)
        case 3:
            let firstSignRect = signRect.offsetBy(dx: 0, dy: -signHeight-interSignHeight)
            let thirdSignRect = signRect.offsetBy(dx: 0, dy: signHeight+interSignHeight)
            drawShape(in: firstSignRect)
            drawShape(in: signRect)
            drawShape(in: thirdSignRect)
        default: break
        }

    }
    
    private func drawShape(in rect: CGRect) {
        let path: UIBezierPath
        switch sign {
        case .squiggle: path = drawSquiggle(in: rect)
        case .diamond: path = drawDiamond(in: rect)
        case .oval: path = drawOval(in: rect)
        }
        path.lineWidth = 3.0
        path.stroke()
        switch fill {
        case .solid: path.fill()
        case .striped:
            stripeShape(path: path, in: rect)
        default: break
        }
    }
    private func drawSquiggle(in rect: CGRect) -> UIBezierPath {
        let upperSquiggle = UIBezierPath()
       let sqdx = rect.width * 0.1
       let sqdy = rect.height * 0.2
       upperSquiggle.move(to: CGPoint(x: rect.minX, y: rect.midY))
       upperSquiggle.addCurve(to:
                          CGPoint(x: rect.minX + rect.width * 1/2,
                                  y: rect.minY + rect.height / 8),
           controlPoint1: CGPoint(x: rect.minX,
                                  y: rect.minY),
           controlPoint2: CGPoint(x: rect.minX + rect.width * 1/2 - sqdx,
                                  y: rect.minY + rect.height / 8 - sqdy))
        upperSquiggle.addCurve(to:
                          CGPoint(x: rect.minX + rect.width * 4/5,
                                  y: rect.minY + rect.height / 8),
           controlPoint1: CGPoint(x: rect.minX + rect.width * 1/2 + sqdx,
                                  y: rect.minY + rect.height / 8 + sqdy),
           controlPoint2: CGPoint(x: rect.minX + rect.width * 4/5 - sqdx,
                                  y: rect.minY + rect.height / 8 + sqdy))

        upperSquiggle.addCurve(to:
                          CGPoint(x: rect.minX + rect.width,
                                  y: rect.minY + rect.height / 2),
           controlPoint1: CGPoint(x: rect.minX + rect.width * 4/5 + sqdx,
                                  y: rect.minY + rect.height / 8 - sqdy ),
           controlPoint2: CGPoint(x: rect.minX + rect.width,
                                  y: rect.minY))
  
       let lowerSquiggle = UIBezierPath(cgPath: upperSquiggle.cgPath)
       lowerSquiggle.apply(CGAffineTransform.identity.rotated(by: CGFloat.pi))
       lowerSquiggle.apply(CGAffineTransform.identity.translatedBy(
                                                           x: bounds.width,
                                                           y: bounds.height))
       upperSquiggle.move(to: CGPoint(x: rect.minX, y: rect.midY))
       upperSquiggle.append(lowerSquiggle)
       return upperSquiggle
    }
    private func drawDiamond(in rect: CGRect) -> UIBezierPath {
        let diamond = UIBezierPath()
        diamond.move(to: CGPoint(x: rect.midX, y: rect.minY))
        diamond.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        diamond.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        diamond.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        diamond.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return diamond
    }
    private func drawOval(in rect: CGRect) -> UIBezierPath {
        let oval = UIBezierPath()
        let radius = rect.height/2
        oval.addArc(withCenter: CGPoint(x: rect.minX+radius, y: rect.minY+radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi*3/2, clockwise: true)
        oval.addLine(to: CGPoint(x: rect.maxX-radius, y: rect.minY))
        oval.addArc(withCenter: CGPoint(x: rect.maxX-radius, y: rect.minY+radius), radius: radius, startAngle: CGFloat.pi*3/2, endAngle: CGFloat.pi/2, clockwise: true)
        oval.addLine(to: CGPoint(x: rect.minX+radius, y: rect.maxY))
       return oval
    }
    private func stripeShape(path: UIBezierPath, in rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        path.addClip()
        let stripe = UIBezierPath()
        stripe.lineWidth = 1.0
        let interStripeSpace: CGFloat = 5.0
        stripe.move(to: CGPoint(x: rect.minX, y: bounds.minY))
        stripe.addLine(to: CGPoint(x: rect.minX, y: bounds.maxY))
        let stripeCount = Int(faceFrame.width / interStripeSpace)
        for _ in 1...stripeCount {
            let translation = CGAffineTransform(translationX: interStripeSpace, y: 0)
            stripe.apply(translation)
            stripe.stroke()
        }
        context?.restoreGState()
    }
    
    func copyCard() -> CardView {
        let copy = CardView()
        copy.signInt = signInt
        copy.colorsInt = colorsInt
        copy.fillInt = fillInt
        copy.quantity = quantity
        copy.isSelected = false
        copy.isFaceUp = true
        copy.bounds = bounds
        copy.center = cardViewCenter
        
        return copy
    }

    override func layoutSubviews() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    func deal(from dealCenter: CGPoint, withBounds bounds: CGRect, withDelay delay: Double) {
        let initialCenter = cardViewCenter
        let initialBounds = self.bounds
        self.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi/2)
        self.frame.size.width = bounds.width
        self.frame.size.height = bounds.height
        self.center = dealCenter
        self.isFaceUp = false
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 1,
            delay: delay,
            options: [],
            animations: {
                self.center = initialCenter
                self.bounds = initialBounds
                self.transform = .identity
        },
            completion: { position in
                UIView.transition(with: self, duration: 0.5, options: [.transitionFlipFromLeft], animations: { self.isFaceUp = true })
        }
        )
    }
}

extension CardView {
    private struct SizeRatio {
        static let maxFaceSizeToBoundsSize: CGFloat = 0.70
        static let cornerRadiusToFaceHeight: CGFloat = 0.06
        static let signHeightToFaceHeight: CGFloat = 0.3
    }
    private var maxFaceFrame: CGRect {
        return bounds.zoomed(by: SizeRatio.maxFaceSizeToBoundsSize)
    }
    private struct AspectRatio {
        static let faceFrame: CGFloat = 0.60
    }
    private var faceFrame: CGRect {
        let facewidth = maxFaceFrame.height
        return maxFaceFrame.insetBy(dx: (maxFaceFrame.width - facewidth)/2, dy: 0)
    }
    private var signHeight: CGFloat {
        return faceFrame.height * SizeRatio.signHeightToFaceHeight
    }
    private var interSignHeight: CGFloat {
        return faceFrame.height - 3*signHeight
    }
    private var radius: CGFloat {
        return faceFrame.height * SizeRatio.cornerRadiusToFaceHeight
    }
}

extension CGRect {
    func zoomed(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: width - newWidth, dy: height - newHeight)
    }
}
