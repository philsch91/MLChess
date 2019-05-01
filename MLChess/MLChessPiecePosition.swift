//
//  MLChessPiecePosition.swift
//  MLChess
//
//  Created by Philipp Schunker on 26.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import Foundation

struct MLChessPiecePosition: Equatable {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}
