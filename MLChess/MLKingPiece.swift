//
//  MLKingPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 04.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLKingPiece: MLChessPiece {
    
    override public init(state:[[MLChessPiece?]], x: Int, y: Int, color: MLPieceColor) {
        super.init(state: state, x: x, y: y, color: color)
        self.value = 10 * self.color.rawValue
    }
    
    required init(from decoder: Decoder) throws {
        //let container = try decoder.container(keyedBy: CodingKeys.self)
        try super.init(from: decoder)
    }
    
    required init() {
        super.init()
    }
    
    public override func getPossibleMoves() -> [[[MLChessPiece?]]] {
        
        return [[[MLChessPiece?]]]()
    }
}
