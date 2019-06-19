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
    var isEnPassantBeatable: Bool = false
    
    override public init(x: Int, y: Int, color: MLPieceColor) {
        super.init(x: x, y: y, color: color)
        self.value = self.color.rawValue
        self.id = self.value
    }
    
    public convenience init(state: [[MLChessPiece?]], x: Int, y: Int, color: MLPieceColor, isEnPassantBeatable: Bool) {
        //convenience initializer must ultimately call a designated initializer
        self.init(state: state, x: x, y: y, color: color)
        self.isEnPassantBeatable = isEnPassantBeatable
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
