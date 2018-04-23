//
//  SetCardView.swift
//  SetCardGame
//
//  Created by Phil Stern on 4/22/18.
//  Copyright © 2018 Phil Stern. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    
    var rank: Int = 0 { didSet { setNeedsDisplay(); setNeedsLayout() } }            // setNeedsDisplay for when card changes
    var symbol: String = "oval" { didSet { setNeedsDisplay(); setNeedsLayout() } }  // setNeedsLayout for when bounds change
    var shading: String = "solid" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var color: UIColor = .red { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var isSelected: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } }

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        UIColor.black.setStroke()
        roundedRect.lineWidth = isSelected ? 5 : 1
        roundedRect.stroke()
        
        let height = self.bounds.size.height;
        
        if (self.rank == 1) {
            drawShapeWithVerticalOffset(voffset: 0.5*height)
        } else if (self.rank == 2) {
            drawShapeWithVerticalOffset(voffset: 0.3*height)
            drawShapeWithVerticalOffset(voffset: 0.7*height)
        } else {
            drawShapeWithVerticalOffset(voffset: 0.2*height)
            drawShapeWithVerticalOffset(voffset: 0.5*height)
            drawShapeWithVerticalOffset(voffset: 0.8*height)
        }
    }

    private func drawShapeWithVerticalOffset(voffset: CGFloat) {
        if self.symbol == "diamond" {
            drawDiamondWithVerticalOffset(voffset: voffset)
        } else if self.symbol == "oval" {
            drawOvalWithVerticalOffset(voffset: voffset)
        } else if self.symbol == "squiggle" {
            drawSquiggleWithVerticalOffset(voffset: voffset)
        }
    }
    
    let DIAMOND_THICKNESS: CGFloat = 0.1  //percent of card width
    
    private func drawDiamondWithVerticalOffset(voffset: CGFloat) {
        let width = self.bounds.size.width
        let diamondThickness = DIAMOND_THICKNESS*width
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.2*width, y: voffset))
        path.addLine(to: CGPoint(x: 0.5*width, y: voffset - diamondThickness))
        path.addLine(to: CGPoint(x: 0.8*width, y: voffset))
        path.addLine(to: CGPoint(x: 0.5*width, y: voffset + diamondThickness))
        path.close()
        
        self.color.setStroke()
        path.stroke()
        
        if let context = UIGraphicsGetCurrentContext() {
            fillShape(path: path, usingContext: context)
        }
    }
    
    let OVAL_THICKNESS: CGFloat = 0.1
    
    private func drawOvalWithVerticalOffset(voffset: CGFloat) {
        let width = self.bounds.size.width
        let ovalThickness = OVAL_THICKNESS*width
        
        let ovalRect = CGRect(x: 0.2*width, y: voffset-ovalThickness, width: 0.6*width, height: 2*ovalThickness)
        let oval = UIBezierPath(ovalIn: ovalRect)
        
        self.color.setStroke()
        oval.stroke()
        
        if let context = UIGraphicsGetCurrentContext() {
            fillShape(path: oval, usingContext: context)
        }
    }
    
    let SQUIGGLE_THICKNESS: CGFloat = 0.08
    
    private func drawSquiggleWithVerticalOffset(voffset: CGFloat) {
        let width = self.bounds.size.width
        let squiggleThickness = SQUIGGLE_THICKNESS*width;
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.3*width, y: voffset-squiggleThickness))
        //top line
        path.addCurve(to: CGPoint(x: 0.7*width, y: voffset-squiggleThickness),
                      controlPoint1: CGPoint(x: 0.5*width, y: voffset-2*squiggleThickness),
                      controlPoint2: CGPoint(x: 0.5*width, y: voffset))
        //right endcap
        path.addCurve(to: CGPoint(x: 0.7*width, y: voffset+squiggleThickness),
                      controlPoint1: CGPoint(x: 0.9*width, y: voffset-2*squiggleThickness),
                      controlPoint2: CGPoint(x: 0.9*width, y: voffset))
        //bottom line
        path.addCurve(to: CGPoint(x: 0.3*width, y: voffset+squiggleThickness),
                      controlPoint1: CGPoint(x: 0.5*width, y: voffset+2*squiggleThickness),
                      controlPoint2: CGPoint(x: 0.5*width, y: voffset))
        //left endcap
        path.addCurve(to: CGPoint(x: 0.3*width, y: voffset-squiggleThickness),
                      controlPoint1: CGPoint(x: 0.1*width, y: voffset+2*squiggleThickness),
                      controlPoint2: CGPoint(x: 0.1*width, y: voffset))
        
        self.color.setStroke()
        path.stroke()
        
        if let context = UIGraphicsGetCurrentContext() {
            fillShape(path: path, usingContext: context)
        }
    }
    
    let STRIPE_SPACING: CGFloat = 0.1

    private func fillShape(path: UIBezierPath, usingContext context: CGContext)
    {
        let context = UIGraphicsGetCurrentContext()
        if context != nil { context!.saveGState() }
        path.addClip()
        
        let width = self.bounds.size.width
        let stripeSpacing = STRIPE_SPACING*width
        let maxDimension = max(self.bounds.size.height, width)
        
        if self.shading == "solid" {
            self.color.setFill()
            UIRectFill(self.bounds);  //fill roundRect clipping area
            
        } else if self.shading == "striped" {
            for i in stride(from: 1.0, to: CGFloat(2*maxDimension/stripeSpacing), by: 1.0) {
                path.move(to: CGPoint(x: i*stripeSpacing, y: 0))
                path.addLine(to: CGPoint(x: 0, y: i*stripeSpacing))
                path.stroke()
            }
        }
        if context != nil { context!.restoreGState() }
    }

}

// extension borrowed from "Developing iOS 11 Apps with Swift", November 2017, Lecture 6

extension SetCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
