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
        /*
        var states: [[[MLChessPiece?]]] = [[[MLChessPiece?]]]()
        
        if !self.isValid(row: self.posY-1, col: self.posX) {
            return states
        }
        
        var copy = self.board
        copy[self.posY][self.posX] = nil
        copy[self.posY-1][self.posX] = self
        states.append(copy)
        */
        let states = self.getPossibleMoves(state: self.board, x: self.posX, y: self.posY)
        return states
    }
    
    override func getPossibleMoves(state: [[MLChessPiece?]], x: Int, y: Int) -> [[[MLChessPiece?]]] {
        var states: [[[MLChessPiece?]]] = [[[MLChessPiece?]]]()
        
        var points = [MLChessPiecePosition(x: x, y: y-1)]
        
        if y == 6 {
            points.append(MLChessPiecePosition(x: x, y: y-2))
        }
        
        for p in points {
            if self.isValid(board: state, row: p.y, col: p.x)
                && self.isEmpty(board: state, row: p.y, col: p.x)
                && self.isFree(board: board, x: x, y: y, newX: p.x, newY: p.y){
                var copy = state
                copy[y][x] = nil
                copy[p.y][p.x] = self
                states.append(copy)
            }
        }
        
        let takePoints = [
            MLChessPiecePosition(x: x-1, y: y-1),
            MLChessPiecePosition(x: x+1, y: y-1)]
        
        for p in takePoints {
            if self.isValid(board: state, row: p.y, col: p.x)
                && self.canTake(board: state, row: p.y, col: p.x) {
                var copy = state
                copy[y][x] = nil
                copy[p.y][p.x] = self
                states.append(copy)
            }
        }
        /*
        if !self.isValid(board: state, row: y-1, col: x) {
            return states
        }
        
        var copy = state
        copy[y][x] = nil
        copy[y-1][x] = self
        states.append(copy)
        */
        return states
    }

}
