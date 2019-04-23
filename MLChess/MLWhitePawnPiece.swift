//
//  MLWhitePawnPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 14.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLWhitePawnPiece: MLPawnPiece {
    
    override func getPossibleMoves() -> [[[MLChessPiece?]]] {
        var moves: [[[MLChessPiece?]]] = [[[MLChessPiece?]]]()
        
        if !self.isValid(row: self.posY+1, col: self.posX) {
            return moves
        }
        
        var copy = self.board
        copy[self.posY][self.posX] = nil
        copy[self.posY+1][self.posX] = self
        moves.append(copy)
        
        return moves
    }
    
    override func getPossibleMoves(state:[[MLChessPiece?]], x: Int, y: Int) -> [[[MLChessPiece?]]] {
        var states: [[[MLChessPiece?]]] = [[[MLChessPiece?]]]()
        if !self.isValid(board: state, row: y+1, col: x) {
            return states
        }
        var copy = state
        copy[y][x] = nil
        copy[y+1][x] = self
        states.append(copy)
        return states
    }

}
