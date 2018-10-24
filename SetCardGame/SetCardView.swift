//
//  SetCardView.swift
//  SetCardGame
//
//  Created by Phil Stern on 4/22/18.
//  Copyright © 2018 Phil Stern. All rights reserved.
//

import UIKit

class SetCardView: UIView {

    // MARK: - Variables
    private struct Constants {
        static let diamondThickness: CGFloat = 0.1  // all are a percentage of card width
        static let ovalThickness: CGFloat = 0.1
        static let squiggleThickness: CGFloat = 0.08
        static let stripeSpacing: CGFloat = 0.13
    }
    var rank: Int = 0
    var symbol: String = "oval"        // init with defaults
    var shading: String = "solid"
    var color: UIColor = .red
    var backColor: UIColor = .white { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var isSelected: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } }

    // MARK: - Functions

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        backColor.setFill()
        UIRectFill(self.bounds)        // fill whole view, limited to clipping path (roundedRect)
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
    
    private func drawDiamondWithVerticalOffset(voffset: CGFloat) {
        let width = self.bounds.size.width
        let diamondThickness = Constants.diamondThickness*width
        
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
    
    private func drawOvalWithVerticalOffset(voffset: CGFloat) {
        let width = self.bounds.size.width
        let ovalThickness = Constants.ovalThickness*width
        
        let ovalRect = CGRect(x: 0.2*width, y: voffset-ovalThickness, width: 0.6*width, height: 2*ovalThickness)
        let oval = UIBezierPath(ovalIn: ovalRect)
        
        self.color.setStroke()
        oval.stroke()
        
        if let context = UIGraphicsGetCurrentContext() {
            fillShape(path: oval, usingContext: context)
        }
    }
    
    private func drawSquiggleWithVerticalOffset(voffset: CGFloat) {
        let width = self.bounds.size.width
        let squiggleThickness = Constants.squiggleThickness*width;
        
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
    
    private func fillShape(path: UIBezierPath, usingContext context: CGContext)
    {
        context.saveGState()
        path.addClip()
        
        let width = self.bounds.size.width
        let stripeSpacing = Constants.stripeSpacing*width
        let maxDimension = max(self.bounds.size.height, width)
        
        if self.shading == "solid" {
            self.color.setFill()
            UIRectFill(self.bounds);
        } else if self.shading == "striped" {
            for i in stride(from: 1.0, to: CGFloat(2*maxDimension/stripeSpacing), by: 1.0) {
                path.move(to: CGPoint(x: i*stripeSpacing, y: 0))
                path.addLine(to: CGPoint(x: 0, y: i*stripeSpacing))
                path.stroke()
            }
        }
        context.restoreGState()
    }

    func setup() {
        self.backgroundColor = nil
        self.isOpaque = false
        self.contentMode = .redraw
    }
    
    required init?(coder aDecoder: NSCoder) {      // init when coming from storyboard
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {                 // init from user (frame is zero, if none given)
        super.init(frame: frame)
        setup()
    }
}

// MARK: - Extensions
// extension borrowed from "Developing iOS 11 Apps with Swift", November 2017, Lecture 6

extension SetCardView {
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
}
