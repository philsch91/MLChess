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
    var color: MLPieceColor!
    
    override init() {
        self.board = [[MLChessPiece?]]()
    }
    
    init(board: [[MLChessPiece?]], color: MLPieceColor) {
        self.board = board
        self.color = color
        super.init()
        
        var nid: String = ""
        for row in self.board {
            for optPiece in row {
                if let piece = optPiece {
                    nid += String(piece.id)
                } else {
                  nid += "0"
                }
            }
        }
        self.nid = nid
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        //print("copy",self.nid)
        //let node: MLChessTreeNode = super.copy(with: zone) as! MLChessTreeNode
        //node.board = [[MLChessPiece?]]()
        let node = MLChessTreeNode()
        node.nid = self.nid
        node.numerator = self.numerator
        node.denominator = self.denominator
        node.nodes = self.nodes
        node.color = self.color
        
        /*
        if let parentNode = self.parent {
            //print("copy parent")
            //node.parent = parentNode.copy() as! MLChessTreeNode
        }
        */
        
        //TODO: NSCopying MLChessPiece
        //var i = 0
        for row in self.board {
            //var j = 0
            var pieceRow = [MLChessPiece?]()
            for piece in row {
                //node.board[i][j] = self.board[i][j]
                //j += 1
                /*
                var newPiece = piece
                if case let exPiece? = piece {
                    newPiece = exPiece.copy() as? MLChessPiece
                }
                pieceRow.append(newPiece)
                */
                pieceRow.append(piece)
            }
            //i += 1
            node.board.append(pieceRow)
        }
        return node
    }
    
}
