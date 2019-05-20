//
//  MLKingPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 04.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLKingPiece: MLChessPiece {
    var isRochadeAvailable: Bool = false
    
    override public init(state:[[MLChessPiece?]], x: Int, y: Int, color: MLPieceColor) {
        super.init(state: state, x: x, y: y, color: color)
        self.value = 10 * self.color.rawValue
        self.id = self.value
        self.isRochadeAvailable = true
    }
    
    public convenience init(state: [[MLChessPiece?]], x: Int, y: Int, color: MLPieceColor, isRochadeAvailable: Bool) {
        //convenience initializer must ultimately call a designated initializer
        self.init(state: state, x: x, y: y, color: color)
        self.isRochadeAvailable = isRochadeAvailable
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
        let kingPiece = MLKingPiece(state: state, x: x, y: y, color: self.color, isRochadeAvailable: false)
        var points = [MLChessPiecePosition]()
        
        points.append(MLChessPiecePosition(x: x-1, y: y))
        points.append(MLChessPiecePosition(x: x+1, y: y))
        points.append(MLChessPiecePosition(x: x, y: y-1))
        points.append(MLChessPiecePosition(x: x, y: y+1))
        points.append(MLChessPiecePosition(x: x-1, y: y-1))
        points.append(MLChessPiecePosition(x: x-1, y: y+1))
        points.append(MLChessPiecePosition(x: x+1, y: y-1))
        points.append(MLChessPiecePosition(x: x+1, y: y+1))
        
        for p in points {
            if self.isValid(board: state, row: p.y, col: p.x)
                && (self.isEmpty(board: state, row: p.y, col: p.x)
                    || self.canTake(board: state, row: p.y, col: p.x)){
                
                var copy = state
                copy[y][x] = nil
                copy[p.y][p.x] = kingPiece
                states.append(copy)
            }
        }
        
        if self.isRochadeAvailable {
            if isFree(board: state, x: x, y: y, newX: 1, newY: y) {
                if let piece = state[0][0] {
                    if piece is MLRookPiece && piece.color == self.color {
                        //let kingPiece = MLKingPiece(state: state, x: 2, y: 0, color: self.color, isRochadeAvailable: false)
                        var copy = state
                        copy[0][2] = kingPiece
                        copy[y][x] = nil
                        copy[0][3] = MLRookPiece(state: state, x: 3, y: 0, color: self.color)
                        copy[0][0] = nil
                        states.append(copy)
                    }
                }
            }
            
            if isFree(board: state, x: x, y: y, newX: 6, newY: 0) {
                if let piece = state[0][7] {
                    if piece is MLRookPiece && piece.color == self.color {
                        //let kingPiece = MLKingPiece(state: state, x: 6, y: 0, color: self.color, isRochadeAvailable: false)
                        var copy = state
                        copy[0][6] = kingPiece
                        copy[y][x] = nil
                        copy[0][5] = MLRookPiece(state: state, x: 5, y: 0, color: self.color)
                        copy[0][7] = nil
                        states.append(copy)
                    }
                }
            }
        }
        
        return states
    }
}
