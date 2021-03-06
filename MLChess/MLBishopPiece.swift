//
//  MLBishopPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 05.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLBishopPiece: MLChessPiece {
    
    override public init(x: Int, y: Int, color: MLPieceColor) {
        super.init(x: x, y: y, color: color)
        self.value = 3 * self.color.rawValue
        self.id = 4 * self.color.rawValue
    }
    
    public convenience init(state: [[MLChessPiece?]], x: Int, y: Int, color: MLPieceColor) {
        //convenience initializer must ultimately call a designated initializer
        self.init(x: x, y: y, color: color)
        self.board = state
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    required init() {
        super.init()
    }
    
    override public func getPossibleMoves() -> [[[MLChessPiece?]]] {
        return [[[MLChessPiece?]]]()
    }
    
    override public func getPossibleMoves(state: [[MLChessPiece?]], x: Int, y: Int) -> [[[MLChessPiece?]]] {
        var states: [[[MLChessPiece?]]] = [[[MLChessPiece?]]]()
        var points = [MLChessPiecePosition]()
        
        for i in -7...7 {
            if x+i == x || y+1 == y {
                continue
            }
            
            var pos = MLChessPiecePosition(x: x+i, y: y+i)
            if !points.contains(pos) {
                points.append(pos)
            }
            
            pos = MLChessPiecePosition(x: x-i, y: y+i)
            if !points.contains(pos) {
                points.append(pos)
            }
            
            pos = MLChessPiecePosition(x: x+i, y: y-i)
            if !points.contains(pos) {
                points.append(pos)
            }
        }
        
        for p in points {
            /*
            let b = self.isFree(board: state, x: 2, y: 0, newX: 7, newY: 5)
            if b {
                print("##########")
            }*/
            if self.isValid(board: state, row: p.y, col: p.x)
                && self.isFree(board: state, x: x, y: y, newX: p.x, newY: p.y)
                && (self.isEmpty(board: state, row: p.y, col: p.x)
                    || self.canTake(board: state, row: p.y, col: p.x)){
                var copy = state
                copy[y][x] = nil
                copy[p.y][p.x] = self
                states.append(copy)
            }
        }
        
        return states
    }
}
