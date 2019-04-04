//
//  MLChessBoardViewController.swift
//  MLChess
//
//  Created by Philipp Schunker on 04.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLChessBoardViewController: NSObject {
    var board: MLChessBoardView
    var views: [UIView]
    
    init(_ board: MLChessBoardView) {
        self.board = board
        self.views = [UIView]()
        super.init()
    }
    
    func updateView(state: [[MLChessPiece?]]){
        print("updateView")
        var frame: CGRect = self.board.rect
        //41,875
        for row in 0...7 {
            for col in 0...7{
                if case let piece? = state[row][col] {
                    if piece is MLKingPiece && piece.color == MLPieceColor.black {
                        print(row,col,"king")
                        print(frame)
                        let fig = MLBlackKingView(frame: frame)
                        fig.center = CGPoint(x: frame.origin.x+(frame.size.width/2), y: frame.origin.y+(frame.size.height/2))
                        print(row,col,fig.frame.origin,fig.frame.size)
                        fig.center.x += 3
                        self.board.addSubview(fig)
                        self.views.append(fig)
                    }
                    if piece is MLKingPiece && piece.color == MLPieceColor.white {
                        print(row,col,"king")
                        print(frame)
                        let fig = MLWhiteKingView(frame: frame)
                        fig.center = CGPoint(x: frame.origin.x+(frame.size.width/2), y: frame.origin.y+(frame.size.height/2))
                        print(row,col,fig.frame.origin,fig.frame.size)
                        fig.center.x += 3
                        self.board.addSubview(fig)
                        self.views.append(fig)
                    }
                }
                frame.origin.x += frame.size.width
            }
            frame.origin.y += frame.size.height
        }
    }
    
    func reset() -> Void {
        for view in self.views {
            view.removeFromSuperview()
        }
    }

}
