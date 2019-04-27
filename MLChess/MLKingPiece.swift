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
    
    override public func getPossibleMoves() -> [[[MLChessPiece?]]] {
        return [[[MLChessPiece?]]]()
    }
    
    override public func getPossibleMoves(state: [[MLChessPiece?]], x: Int, y: Int) -> [[[MLChessPiece?]]] {
        var states: [[[MLChessPiece?]]] = [[[MLChessPiece?]]]()
        
        var points = [MLChessPiecePosition]()
        
        points.append(MLChessPiecePosition(x: x-1, y: y))
        points.append(MLChessPiecePosition(x: x+1, y: y))
        points.append(MLChessPiecePosition(x: x, y: y-1))
        points.append(MLChessPiecePosition(x: x, y: y+1))
        
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
