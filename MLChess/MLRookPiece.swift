//
//  MLRookPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 03.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLRookPiece: MLChessPiece {
    
    public init(board:[[MLChessPiece]], posX: Int, posY: Int) {
        super.init()
    }
    
    public override func getPossibleMoves() -> [[[MLChessPiece]]] {
        return [[[MLChessPiece]]]()
    }
}
