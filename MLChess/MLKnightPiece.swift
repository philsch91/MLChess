//
//  MLKnightPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 05.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLKnightPiece: MLChessPiece {
    
    override public init(state:[[MLChessPiece?]], x: Int, y: Int, color: MLPieceColor) {
        super.init(state: state, x: x, y: y, color: color)
        self.value = 3 * self.color.rawValue
        self.id = self.value
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
    
    override public func getPossibleMoves(state: [[MLChessPiece?]], x: Int, y: Int) -> [[[MLChessPiece?]]] {
        var states: [[[MLChessPiece?]]] = [[[MLChessPiece?]]]()
        
        var points = [MLChessPiecePosition]()
        
        points.append(MLChessPiecePosition(x: x-2, y: y-1))
        points.append(MLChessPiecePosition(x: x-2, y: y+1))
        points.append(MLChessPiecePosition(x: x-1, y: y-2))
        points.append(MLChessPiecePosition(x: x-1, y: y+2))
        
        points.append(MLChessPiecePosition(x: x+1, y: y-2))
        points.append(MLChessPiecePosition(x: x+1, y: y+2))
        points.append(MLChessPiecePosition(x: x+2, y: y-1))
        points.append(MLChessPiecePosition(x: x+2, y: y+1))
        
        for p in points {
            if self.isValid(board: state, row: p.y, col: p.x)
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
