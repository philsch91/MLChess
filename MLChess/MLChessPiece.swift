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
        print(row,col)
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
        print(self,"isFree",x,y,newX,newY)
        var lowerBoundX: Int
        let upperBoundX: Int
        var lowerBoundY: Int
        let upperBoundY: Int
        var positions = [MLChessPiecePosition]()
        
        if x == newX && y == newY {
            print("return early")
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
        
        if lowerBoundX != upperBoundX && lowerBoundY != upperBoundY {
            var xA = [Int]()
            var yA = [Int]()
            
            for i in lowerBoundX...upperBoundX {
                xA.append(i)
            }
            for j in lowerBoundY...upperBoundY {
                yA.append(j)
            }
            for k in 1..<xA.count {
                //print("#####",xA[k],yA[k])
                positions.append(MLChessPiecePosition(x: xA[k], y: yA[k]))
            }
        } else if lowerBoundX != upperBoundX {
            var xA = [Int]()
            
            for i in lowerBoundX...upperBoundX {
                xA.append(i)
            }
            for k in 1..<xA.count {
                positions.append(MLChessPiecePosition(x: xA[k], y: y))
            }
            
        } else if lowerBoundY != upperBoundY {
            var yA = [Int]()
            
            for i in lowerBoundY...upperBoundY {
                yA.append(i)
            }
            for k in 1..<yA.count {
                positions.append(MLChessPiecePosition(x: x, y: yA[k]))
            }
        }
        
        for pos in positions {
            print(pos)
            if !isEmpty(board: board, row: pos.y, col: pos.x){
                print("isFree false")
                return false
            }
        }
        print("isFree true")
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
        pieceCopy.value = self.value
        return pieceCopy
    }
    
    //MARK: - CodingKey
    
    enum CodingKeys: String, CodingKey {
        case id
        case value
    }
}
