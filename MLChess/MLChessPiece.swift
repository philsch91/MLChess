//
//  MLChessPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 02.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLChessPiece: NSObject {
    var board: [[MLChessPiece?]]     //= [[MLChessPiece]]()
    var posX: Int
    var posY: Int
    var color: MLPieceColor
    
    override internal init() {
        self.board = [[MLChessPiece]]()
        self.posX = 0
        self.posY = 0
        self.color = MLPieceColor.black
    }
    
    public func getPossibleMoves() -> [[[MLChessPiece]]] {
        return [[[MLChessPiece]]]()
    }
}
