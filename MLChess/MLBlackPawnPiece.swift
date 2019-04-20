//
//  MLBlackPawnPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 14.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLBlackPawnPiece: MLPawnPiece {
    
    override func getPossibleMoves() -> [[[MLChessPiece?]]] {
        
        var moves: [[[MLChessPiece?]]] = [[[MLChessPiece?]]]()
        
        if !self.isValid(row: self.posX, col: self.posY+1) {
            return moves
        }
        
        var copy = self.board
        copy[self.posY][self.posX] = nil
        copy[self.posY+1][self.posX] = self
        moves.append(copy)
        
        return moves
    }

}
