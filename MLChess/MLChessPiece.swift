//
//  MLChessPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 02.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLChessPiece: NSObject {
    
    func getPossibleMoves() -> Array<Int> {
        return Array(repeating: 0, count: 64)
    }
}
