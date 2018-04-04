//
//  TwitSplitTests.swift
//  TwitSplitTests
//
//  Created by Tèo Lực on 4/4/18.
//  Copyright © 2018 Luc Nguyen. All rights reserved.
//

import XCTest
@testable import TwitSplit

class TwitSplitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func splitMessage(_ message: String) {
        let chunkSize = 50
        if let chunks = message.splitText(chunkSize) {
            for (index, chunk) in chunks.enumerated() {
                print("\(index)/\(chunks.count) \(chunk)")
            }
        }
    }
    
    func testSplitMessage() {
        splitMessage("I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself")
    }
    
}
