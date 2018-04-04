//
//  BubbleView.swift
//  TwitSplit
//
//  Created by Tèo Lực on 4/4/18.
//  Copyright © 2018 Luc Nguyen. All rights reserved.
//

import UIKit

 @IBDesignable class BubbleView: UIView {
    @IBInspectable var color: UIColor = BubbleStyleKit.defaultColor {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
   @IBInspectable var showQuoteSymbol: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        BubbleStyleKit.drawBubbleCanvas(frame: self.bounds, color: self.color, showQuoteSymbol: self.showQuoteSymbol)
    }
}
