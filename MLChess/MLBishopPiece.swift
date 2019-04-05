//
//  MLBishopPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 05.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLBishopPiece: MLChessPiece {
    
    public init(state:[[MLChessPiece?]], x: Int, y: Int, color: MLPieceColor) {
        super.init()
        self.board = state
        self.posX = x
        self.posY = y
        self.color = color
    }
    
    public override func getPossibleMoves() -> [[[MLChessPiece]]] {
        
        return [[[MLChessPiece]]]()
    }
}
