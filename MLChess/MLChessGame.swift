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
        var black1: [MLChessPiece?] = [MLChessPiece?]()
        black1.append(MLKingPiece(state: self.board, x: 0, y: 0, color: MLPieceColor.black))
        black1.append(nil)
        black1.append(nil)
        black1.append(nil)
        black1.append(nil)
        black1.append(nil)
        black1.append(nil)
        black1.append(MLKingPiece(state: self.board, x: 0, y: 1, color: MLPieceColor.white))
        self.board.append(black1)
        
        let empty: [MLChessPiece?] = Array(repeating: nil, count: 8)
        for _ in 1...7 {
            self.board.append(empty)
        }
    }
    
}
