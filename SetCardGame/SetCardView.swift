//
//  SetCardView.swift
//  SetCardGame
//
//  Created by Phil Stern on 4/22/18.
//  Copyright © 2018 Phil Stern. All rights reserved.
//

import UIKit

class SetCardView: UIView {

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
    }

}
