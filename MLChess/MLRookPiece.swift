//
//  MLRookPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 03.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLRookPiece: MLChessPiece {
    var isRochadeAvailable: Bool = false
    
    override public init(x: Int, y: Int, color: MLPieceColor) {
        super.init(x: x, y: y, color: color)
        //self.board = state
        self.value = 5 * self.color.rawValue
        self.id = self.value
        self.isRochadeAvailable = true
    }
    
    public convenience init(state: [[MLChessPiece?]], x: Int, y: Int, color: MLPieceColor, isRochadeAvailable: Bool) {
        //convenience initializer must ultimately call a designated initializer
        self.init(state: state, x: x, y: y, color: color)
        //self.board = state //already in self.init()
        self.isRochadeAvailable = isRochadeAvailable
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    required init() {
        super.init()
    }
    
    public override func getPossibleMoves() -> [[[MLChessPiece?]]] {
        //return [[[MLChessPiece?]]]()
        guard let board = self.board else {
            return [[[MLChessPiece?]]]()
        }
        
        let states = self.getPossibleMoves(state: board, x: self.posX, y: self.posY)
        return states
    }
    
    override func getPossibleMoves(state: [[MLChessPiece?]], x: Int, y: Int) -> [[[MLChessPiece?]]] {
        var states: [[[MLChessPiece?]]] = [[[MLChessPiece?]]]()
        let rookPiece = MLRookPiece(state: state, x: x, y: y, color: self.color, isRochadeAvailable: false)
        //let points = [MLChessPiecePosition(x: x, y: y-1)]
        var points = [MLChessPiecePosition]()
        
        for nx in 0...x {
            let pos = MLChessPiecePosition(x: nx, y: y)
            points.append(pos)
        }
        
        for nx in x...7 {
            let pos = MLChessPiecePosition(x: nx, y: y)
            points.append(pos)
        }
        
        for ny in 0...y {
            let pos = MLChessPiecePosition(x: x, y: ny)
            points.append(pos)
        }
        
        for ny in y...7 {
            let pos = MLChessPiecePosition(x: x, y: ny)
            points.append(pos)
        }
        
        for p in points {
            if self.isValid(board: state, row: p.y, col: p.x)
                && self.isFree(board: state, x: x, y: y, newX: p.x, newY: p.y)
                && (self.isEmpty(board: state, row: p.y, col: p.x)
                    || self.canTake(board: state, row: p.y, col: p.x)){
                var copy = state
                copy[y][x] = nil
                copy[p.y][p.x] = rookPiece
                states.append(copy)
            }
        }
        
        return states
    }
}
