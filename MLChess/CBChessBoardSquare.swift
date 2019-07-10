//
//  CBChessBoardSquare.swift
//  MLChess
//
//  Created by Philipp Schunker on 10.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

struct CBChessBoardSquare {
    public var index: Int
    public var row: Int
    public var col: Int
    public var id: String
    
    public init(_ index: Int) {
        self.index = index
        self.row = 0
        self.col = 0
        
        var i: Int = 0
        for row in 0...7 {
            for col in 0...7 {
                if i == index {
                    self.row = row
                    self.col = col
                }
                i += 1
            }
        }
        
        self.id = String(format: "%c", col+65) + String(row+1)
    }
}
