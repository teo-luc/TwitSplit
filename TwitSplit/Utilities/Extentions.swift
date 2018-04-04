//
//  Extentions.swift
//  TwitSplit
//
//  Created by Tèo Lực on 4/3/18.
//  Copyright © 2018 Luc Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    static func digits(from number: Int) -> Int {
        if (abs(number) < 10) {
            return 1
        } else {
            return 1 + digits(from: number/10)
        }
    }
    
    func countDigits() -> Int {
        return Int.digits(from: self)
    }
}

extension String {
    private func lastIndexOf(_ input: String, starting: Int) -> String.Index? {
        if starting >= 0 {
            return self.range(of: input, options: .backwards, range: Range.init(NSMakeRange(0, starting), in: self))?.lowerBound
        }
        return nil
    }
    
    private func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func splitText(_ chunkSize: Int) -> [String]? {
        var chunks = [String]()
        // Calculate average total chunks
        let avgTotalChunks = Int((Float(self.count)/Float(chunkSize)).rounded(.up))
        var newText = self
        while newText.count > chunkSize {
            // calculate `total digits of paging`
            let suggestDecreaseDigits = avgTotalChunks.countDigits() + (chunks.count + 1).countDigits() + 2 /*includes: '/' & '<space>'*/
            // Find last index from chunkSize (without `total digits of paging`)
            let starting = chunkSize - suggestDecreaseDigits;
            if let index = newText.lastIndexOf(" ", starting: starting) {
                // Split the string from [0, index)
                let chunk = newText[..<index]
                chunks.append(String(chunk))
                // Split the string from (index, end]
                let splitString = newText[String.Index.init(encodedOffset: index.encodedOffset+1)..<newText.endIndex]
                // Assign a new text and continue split the text
                newText = String(splitString).trim()
            } else {
                if newText.count > starting {
                    // If the message contains a span of non-whitespace characters longer than 50 characters, display an error.
                    return nil /*Error Case*/
                } else {
                    // Split the string from [0, chunkSize]
                    let chunk = newText[...String.Index.init(encodedOffset: chunkSize)]
                    chunks.append(String(chunk))
                    // Split the string from [chunkSize, end]
                    let splitString = newText[String.Index.init(encodedOffset: chunkSize)..<newText.endIndex]
                    // Assign a new text and continue split the text
                    newText = String(splitString).trim()
                }
            }
        }
        chunks.append(newText)
        return chunks
    }
}

extension UIView {
    func layoutIfNeeded(animation duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
           self.layoutIfNeeded()
        }
    }
}
