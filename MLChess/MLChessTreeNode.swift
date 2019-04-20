//
//  MLChessTreeNode.swift
//  MLChess
//
//  Created by Philipp Schunker on 20.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit
import MonteCarloKit

class MLChessTreeNode: MCTreeNode {
    var board: [[MLChessPiece?]]
    
    override init() {
        self.board = [[MLChessPiece?]]()
    }
    
    init(board: [[MLChessPiece?]]) {
        self.board = board
    }
    
}
