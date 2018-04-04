//
//  ConnerView.swift
//  TwitSplit
//
//  Created by Tèo Lực on 4/4/18.
//  Copyright © 2018 Luc Nguyen. All rights reserved.
//

import UIKit

@IBDesignable class ConnerView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        BubbleStyleKit.drawRoundRect(frame: self.bounds)
    }
}
