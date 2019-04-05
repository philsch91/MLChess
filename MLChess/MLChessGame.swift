//
//  MLChessGame.swift
//  MLChess
//
//  Created by Philipp Schunker on 02.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLChessGame: NSObject {
    var board: [[MLChessPiece?]] = [[MLChessPiece?]]()
    
    override init() {
        var white1: [MLChessPiece?] = [MLChessPiece?]()
        white1.append(MLRookPiece(state: self.board, x: 0, y: 0, color: MLPieceColor.white))
        white1.append(MLKnightPiece(state: self.board, x: 1, y: 0, color: MLPieceColor.white))
        white1.append(MLBishopPiece(state: self.board, x: 2, y: 0, color: MLPieceColor.white))
        white1.append(MLQueenPiece(state: self.board, x: 3, y: 0, color: MLPieceColor.white))
        white1.append(MLKingPiece(state: self.board, x: 4, y: 0, color: MLPieceColor.white))
        white1.append(MLBishopPiece(state: self.board, x: 5, y: 0, color: MLPieceColor.white))
        white1.append(MLKnightPiece(state: self.board, x: 6, y: 0, color: MLPieceColor.white))
        white1.append(MLRookPiece(state: self.board, x: 7, y: 0, color: MLPieceColor.white))
        self.board.append(white1)
        
        var white2: [MLChessPiece?] = [MLChessPiece?]()
        for col in 0...7 {
            white2.append(MLPawnPiece(state: self.board, x: col, y: 1, color: MLPieceColor.white))
        }
        self.board.append(white2)
        
        let empty: [MLChessPiece?] = Array(repeating: nil, count: 8)
        for _ in 2...5 {
            self.board.append(empty)
        }
        
        var black2: [MLChessPiece?] = [MLChessPiece?]()
        for col in 0...7 {
            black2.append(MLPawnPiece(state: self.board, x: col, y: 6, color: MLPieceColor.black))
        }
        self.board.append(black2)
        
        var black1: [MLChessPiece?] = [MLChessPiece?]()
        black1.append(MLRookPiece(state: self.board, x: 0, y: 7, color: MLPieceColor.black))
        black1.append(MLKnightPiece(state: self.board, x: 1, y: 7, color: MLPieceColor.black))
        black1.append(MLBishopPiece(state: self.board, x: 2, y: 7, color: MLPieceColor.black))
        black1.append(MLQueenPiece(state: self.board, x: 3, y: 7, color: MLPieceColor.black))
        black1.append(MLKingPiece(state: self.board, x: 4, y: 7, color: MLPieceColor.black))
        black1.append(MLBishopPiece(state: self.board, x: 5, y: 7, color: MLPieceColor.black))
        black1.append(MLKnightPiece(state: self.board, x: 6, y: 7, color: MLPieceColor.black))
        black1.append(MLRookPiece(state: self.board, x: 7, y: 7, color: MLPieceColor.black))
        self.board.append(black1)
    }
    
}
