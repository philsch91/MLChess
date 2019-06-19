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
        guard let board = self.board else {
            return [[[MLChessPiece?]]]()
        }
        let states = self.getPossibleMoves(state: board, x: self.posX, y: self.posY)
        return states
    }
    
    override func getPossibleMoves(state: [[MLChessPiece?]], x: Int, y: Int) -> [[[MLChessPiece?]]] {
        var states: [[[MLChessPiece?]]] = [[[MLChessPiece?]]]()
        var newPiece: MLChessPiece = self
        var points = [MLChessPiecePosition(x: x, y: y-1)]
        
        if self.isEnPassantBeatable {
            self.isEnPassantBeatable = false
        }
        
        if y == 6 {
            points.append(MLChessPiecePosition(x: x, y: y-2))
            newPiece = MLBlackPawnPiece(state: state, x: x, y: y-2, color: self.color, isEnPassantBeatable: true)
        }
        
        if points[0].y == 0 {
            newPiece = MLQueenPiece(state: state, x: points[0].x, y: points[0].y, color: self.color)
        }
        
        for p in points {
            if self.isValid(board: state, row: p.y, col: p.x)
                && self.isEmpty(board: state, row: p.y, col: p.x)
                && self.isFree(board: state, x: x, y: y, newX: p.x, newY: p.y){
                var copy = state
                copy[y][x] = nil
                copy[p.y][p.x] = newPiece
                states.append(copy)
            }
        }
        
        let beatPoints = [
            MLChessPiecePosition(x: x-1, y: y-1),
            MLChessPiecePosition(x: x+1, y: y-1)]
        
        if beatPoints[0].y == 0 {
            newPiece = MLQueenPiece(state: state, x: points[0].x, y: points[0].y, color: self.color)
        }
        
        for p in beatPoints {
            if self.isValid(board: state, row: p.y, col: p.x)
                && self.canTake(board: state, row: p.y, col: p.x) {
                var copy = state
                copy[y][x] = nil
                copy[p.y][p.x] = newPiece
                states.append(copy)
            }
        }
        
        let enPassantBeatPoints = [
            MLChessPiecePosition(x: x-1, y: y),
            MLChessPiecePosition(x: x+1, y: y)]
        
        for p in enPassantBeatPoints {
            if self.isValid(board: state, row: p.y, col: p.x) {
                if let piece = state[p.y][p.x] {
                    if piece is MLWhitePawnPiece {
                        let pawn = piece as! MLWhitePawnPiece
                        if pawn.isEnPassantBeatable {
                            var copy = state
                            copy[y][x] = nil
                            copy[p.y][p.x] = nil
                            copy[p.y-1][p.x] = newPiece
                            states.append(copy)
                        }
                    }
                }
            }
        }
        
        return states
    }

}
