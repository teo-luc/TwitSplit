//
//  BubbleViewCell.swift
//  TwitSplit
//
//  Created by Tèo Lực on 4/4/18.
//  Copyright © 2018 Luc Nguyen. All rights reserved.
//

import UIKit

class BubbleViewCell:  UITableViewCell{
    @IBOutlet weak var messLabel: UILabel!
    @IBOutlet private weak var bubbleView: BubbleView!
    var hasError: Bool = false {
        didSet {
            bubbleView.color = hasError ? BubbleStyleKit.errorColor: BubbleStyleKit.defaultColor
        }
    }
    
    var isLastCell: Bool = false {
        didSet {
            bubbleView.showQuoteSymbol = isLastCell
        }
    }
}
