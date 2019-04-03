//
//  MLChessPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 02.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLChessPiece: NSObject {
    var board: [[MLChessPiece]]     //= [[MLChessPiece]]()
    var posX: Int
    var posY: Int
    
    internal override init() {
        self.board = [[MLChessPiece]]()
        self.posX = 0
        self.posY = 0
    }
    
    public func getPossibleMoves() -> [[[MLChessPiece]]] {
        return [[[MLChessPiece]]]()
    }
}
