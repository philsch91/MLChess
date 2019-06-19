//
//  MLChessGame.swift
//  MLChess
//
//  Created by Philipp Schunker on 02.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLChessGame: NSObject, Codable {
    var board: [[MLChessPiece?]] = [[MLChessPiece?]]()
    var moves: [[[MLChessPiece?]]]
    var active: MLPieceColor!
    
    override init() {
        var white1: [MLChessPiece?] = [MLChessPiece?]()
        white1.append(MLRookPiece(x: 0, y: 0, color: MLPieceColor.white))
        white1.append(MLKnightPiece(x: 1, y: 0, color: MLPieceColor.white))
        //white1.append(nil)
        white1.append(MLBishopPiece(x: 2, y: 0, color: MLPieceColor.white))
        white1.append(MLQueenPiece(x: 3, y: 0, color: MLPieceColor.white))
        white1.append(MLKingPiece(x: 4, y: 0, color: MLPieceColor.white))
        //white1.append(nil)
        white1.append(MLBishopPiece(x: 5, y: 0, color: MLPieceColor.white))
        white1.append(MLKnightPiece(x: 6, y: 0, color: MLPieceColor.white))
        //white1.append(nil)
        white1.append(MLRookPiece(x: 7, y: 0, color: MLPieceColor.white))
        self.board.append(white1)
        
        var white2: [MLChessPiece?] = [MLChessPiece?]()
        for col in 0...7 {
            white2.append(MLWhitePawnPiece(x: col, y: 1, color: MLPieceColor.white))
        }
        self.board.append(white2)
 
        let empty: [MLChessPiece?] = Array(repeating: nil, count: 8)
        for _ in 2...5 {
            //let empty2: [MLChessPiece?] = Array(repeating: MLChessPiece(), count: 8)
            //self.board.append(empty2)
            self.board.append(empty)
        }
        
        var black2: [MLChessPiece?] = [MLChessPiece?]()
        for col in 0...7 {
            black2.append(MLBlackPawnPiece(x: col, y: 6, color: MLPieceColor.black))
        }
        self.board.append(black2)
        
        var black1: [MLChessPiece?] = [MLChessPiece?]()
        black1.append(MLRookPiece(x: 0, y: 7, color: MLPieceColor.black))
        black1.append(MLKnightPiece(x: 1, y: 7, color: MLPieceColor.black))
        black1.append(MLBishopPiece(x: 2, y: 7, color: MLPieceColor.black))
        black1.append(MLQueenPiece(x: 3, y: 7, color: MLPieceColor.black))
        black1.append(MLKingPiece(x: 4, y: 7, color: MLPieceColor.black))
        black1.append(MLBishopPiece(x: 5, y: 7, color: MLPieceColor.black))
        black1.append(MLKnightPiece(x: 6, y: 7, color: MLPieceColor.black))
        black1.append(MLRookPiece(x: 7, y: 7, color: MLPieceColor.black))
        self.board.append(black1)
        
        //print(self.board)
        /*
        for row in self.board {
            for optionalPiece in row {
                if let piece = optionalPiece {
                    piece.board = self.board
                }
            }
        }
        //print(white1[0]?.board)
        */
        
        self.moves = [[[MLChessPiece?]]]()
        self.active = MLPieceColor.white
    }
    
    //MARK: - CodingKey
    
    enum CodingKeys: String, CodingKey {
        case board
        case moves
        case active
    }
    
}
