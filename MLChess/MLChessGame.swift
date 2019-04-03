//
//  MLChessGame.swift
//  MLChess
//
//  Created by Philipp Schunker on 02.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLChessGame: NSObject {
    var board: [[MLChessPiece]] = [[MLChessPiece]]()
    
    override init() {
        //self.state[0][0] = MLRookPiece()
        self.board[0][0] = MLRookPiece(board: self.board, posX: 0, posY: 0)
    }
    
}
