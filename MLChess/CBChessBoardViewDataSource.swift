//
//  CBChessBoardViewDataSource.swift
//  MLChess
//
//  Created by Philipp Schunker on 10.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import Foundation

protocol CBChessBoardViewDataSource : class {
    func chessBoardView(board: MLChessBoardView, chessPieceForSquare square: CBChessBoardSquare) -> CBChessBoardPiece?
}
