//
//  MLPawnPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 05.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLPawnPiece: MLChessPiece {
    
    var moved = false
    
    override public init(state:[[MLChessPiece?]], x: Int, y: Int, color: MLPieceColor) {
        super.init(state: state, x: x, y: y, color: color)
        self.value = self.color.rawValue
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    required init() {
        super.init()
    }
    
    public override func getPossibleMoves() -> [[[MLChessPiece?]]] {
        
        return [[[MLChessPiece?]]]()
    }
}
