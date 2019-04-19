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
    
    public func getPossibleMoves() -> [[[MLChessPiece]]] {
        return [[[MLChessPiece]]]()
    }
    
    //MARK: - CodingKey
    
    enum CodingKeys: String, CodingKey {
        case value
    }
}
