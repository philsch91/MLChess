//
//  MLChessPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 02.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLChessPiece: NSObject, Codable {
    var board: [[MLChessPiece?]] = [[MLChessPiece]]()
    var posX: Int = 0
    var posY: Int = 0
    var color: MLPieceColor = MLPieceColor.black
    var value: Int = 0
    
    override init() {
        //self.board = [[MLChessPiece]]()
        //self.posX = 0
        //self.posY = 0
        //self.color = MLPieceColor.black
    }
    
    public func isValid(row: Int, col: Int) -> Bool {
        if row < 0 || row > 7 || col < 0 || col > 7 {
            return false
        }
        
        if case let piece? = self.board[row][col] {
            if piece.color == self.color {
                return false
            }
        }
        return true
    }
    
    public func getPossibleMoves() -> [[[MLChessPiece?]]] {
        return [[[MLChessPiece?]]]()
    }
    
    //MARK: - CodingKey
    
    enum CodingKeys: String, CodingKey {
        case value
    }
}
