//
//  MLChessboard.swift
//  MLChess
//
//  Created by Philipp Schunker on 27.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit
import CoreGraphics

class MLChessboard: UIView {
    
    let size: Float = 0
    
    override init(frame: CGRect) {
        //self.size=Float(frame.size.width-20.0)
        super.init(frame: frame)
        self.backgroundColor = UIColor.brown
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //print(rect)
        
        let squareSize: CGFloat = (rect.width-40)/8
        let origin = CGPoint(x: 20, y: rect.height-squareSize-20)
        let context = UIGraphicsGetCurrentContext()
        var tst: WhiteKing
        
        print(origin)
        
        for row in 0...7 {
            for col in 0...7{
                let square = CGRect(x: origin.x+(CGFloat(col)*squareSize), y: origin.y-(CGFloat(row)*squareSize), width: squareSize, height: squareSize)
                //print(square.origin)
                
                if (row+col)%2 == 0{
                    print("row ",row," col ",col," white")
                    context?.setFillColor(UIColor.white.cgColor)
                } else {
                    print("row ",row," col ",col," black")
                    context?.setFillColor(UIColor.black.cgColor)
                }
                
                context?.fill(square)
                tst = WhiteKing(frame: square)
                self.addSubview(tst)
            }
        }
        
    }
    

}
