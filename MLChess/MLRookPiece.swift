//
//  MLRookPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 03.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLRookPiece: MLChessPiece {
    
    public init(state:[[MLChessPiece?]], x: Int, y: Int, color: MLPieceColor) {
        super.init()
        self.board = state
        self.posX = x
        self.posY = y
        self.color = color
        self.value = 5 * self.color.rawValue
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    public override func getPossibleMoves() -> [[[MLChessPiece?]]] {
        
        return [[[MLChessPiece?]]]()
    }
}
