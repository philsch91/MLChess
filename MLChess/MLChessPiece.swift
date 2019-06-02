//
//  MLChessPiece.swift
//  MLChess
//
//  Created by Philipp Schunker on 02.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLChessPiece: NSObject, NSCopying, Codable {
    
    var board: [[MLChessPiece?]] = [[MLChessPiece]]()
    var posX: Int = 0
    var posY: Int = 0
    var color: MLPieceColor = MLPieceColor.black
    var id: Int = 0
    var value: Int = 0
    
    required override init() {
    }
    
    public init(state:[[MLChessPiece?]], x: Int, y: Int, color: MLPieceColor) {
        super.init()
        self.board = state
        self.posX = x
        self.posY = y
        self.color = color
    }
    
    public func isValid(row: Int, col: Int) -> Bool {
        if row < 0 || row > 7 || col < 0 || col > 7 {
            return false
        }
        //print("isValid",row,col)
        if case let piece? = self.board[row][col] {
            if piece.color == self.color {
                return false
            }
        }
        return true
    }
    
    public func isValid(board: [[MLChessPiece?]], row: Int, col: Int) -> Bool {
        if row < 0 || row > 7 || col < 0 || col > 7 {
            return false
        }
        /*
        if case let piece? = board[row][col] {
            return false
        }
        */
        return true
    }
    
    public func isEmpty(board: [[MLChessPiece?]], row: Int, col: Int) -> Bool {
        if let _ = board[row][col] {
            return false
        }
        return true
    }
    
    public func isFree(board: [[MLChessPiece?]], x: Int, y: Int, newX: Int, newY: Int) -> Bool {
        //print(self,"isFree",x,y,newX,newY)
        var lowerBoundX: Int
        let upperBoundX: Int
        var lowerBoundY: Int
        let upperBoundY: Int
        var positions = [MLChessPiecePosition]()
        
        if x == newX && y == newY {
            //print("return")
            return false
        }
        
        if x < newX {
            lowerBoundX = x
            upperBoundX = newX
        } else if x > newX {
            lowerBoundX = newX
            upperBoundX = x
        } else {
            lowerBoundX = x
            upperBoundX = lowerBoundX
        }
        
        if y < newY {
            lowerBoundY = y
            upperBoundY = newY
        } else if y > newY {
            lowerBoundY = newY
            upperBoundY = y
        } else {
            lowerBoundY = y
            upperBoundY = lowerBoundY
        }
        
        if x != newX && y != newY {
            if !self.isEmpty(board: board, row: newY, col: newX)
                && !self.canTake(board: board, row: newY, col: newX) {
                return false
            }
            
            var xVals = [Int]()
            var yVals = [Int]()
            
            if x < newX {
                for ix in (lowerBoundX+1..<upperBoundX).reversed() {
                    xVals.append(ix)
                }
            } else {
                //3...4
                for ix in lowerBoundX+1..<upperBoundX {
                    xVals.append(ix)
                }
            }
            
            if y < newY {
                //2...1
                for iy in (lowerBoundY+1..<upperBoundY).reversed() {
                    yVals.append(iy)
                }
            } else {
                for iy in lowerBoundY+1..<upperBoundY {
                    yVals.append(iy)
                }
            }
            
            for k in 0..<xVals.count {
                //print("vals",xVals[k],yVals[k])
                positions.append(MLChessPiecePosition(x: xVals[k], y: yVals[k]))
            }
        } else if x != newX {
            if !self.isEmpty(board: board, row: y, col: newX)
                && !self.canTake(board: board, row: y, col: newX) {
                return false
            }
        
            for ix in lowerBoundX+1..<upperBoundX {
                positions.append(MLChessPiecePosition(x: ix, y: y))
            }
        } else if y != newY {
            if !self.isEmpty(board: board, row: newY, col: x)
                && !self.canTake(board: board, row: newY, col: x) {
                return false
            }
            
            for iy in lowerBoundY+1..<upperBoundY {
                positions.append(MLChessPiecePosition(x: x, y: iy))
            }
        }
        
        for pos in positions {
            //print(pos)
            if !self.isEmpty(board: board, row: pos.y, col: pos.x){
                //print("isFree false")
                return false
            }
        }
        //print("isFree true")
        return true
    }
    
    public func canTake(board: [[MLChessPiece?]], row: Int, col: Int) -> Bool {
        guard let piece = board[row][col] else {
            return false
        }
        
        if piece.color == self.color {
            return false
        }
        
        return true
    }
    
    public func getPossibleMoves() -> [[[MLChessPiece?]]] {
        return [[[MLChessPiece?]]]()
    }
    
    func getPossibleMoves(state:[[MLChessPiece?]], x: Int, y: Int) -> [[[MLChessPiece?]]] {
        return [[[MLChessPiece?]]]()
    }
    
    //MARK: - NSCopying
    
    func copy(with zone: NSZone? = nil) -> Any {
        print("MLChessPiece copy")
        let pieceCopy = type(of: self).init()
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
            pieceCopy.board.append(pieceRow)
        }
        pieceCopy.posX = self.posX
        pieceCopy.posY = self.posY
        pieceCopy.color = self.color
        pieceCopy.id = self.id
        pieceCopy.value = self.value
        return pieceCopy
    }
    
    //MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case id
        //case value
    }
    
    //MARK: - Equatable
    
    static func ==(lhs: MLChessPiece, rhs: MLChessPiece) -> Bool {
        return lhs.id == lhs.id
    }
}
