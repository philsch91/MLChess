//
//  MLChessboard.swift
//  MLChess
//
//  Created by Philipp Schunker on 27.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit
//import CoreGraphics

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
        print("squareSize",squareSize)
        let origin = CGPoint(x: 20, y: rect.height-squareSize-20)
        let context = UIGraphicsGetCurrentContext()
        var tst: MLWhiteKing
        
        print(origin)
        
        for row in 1...8 {
            //let center: CGPoint = CGPoint(x: 5, y: rect.height-(squareSize*CGFloat(row))-20)
            let center: CGPoint = CGPoint(x: 5, y: squareSize*CGFloat(row))
            print("center",center)
            //let frame: CGRect = CGRect(x: 5, y: squareSize*CGFloat(row), width: 10, height: 10)
            let frame: CGRect = CGRect(origin: center, size: CGSize(width: 10, height: 10))
            let label: UILabel = UILabel(frame: frame)  //(10.0, 46.875)
            //label.layer.borderWidth=1     //debug
            //print("label.center",label.center)
            label.center.y -= (label.frame.size.height)     //(10.0, 36.875)
            print("label.center",label.center)
            label.text = String(row)
            label.textColor = UIColor.white
            self.addSubview(label)
            
            //let label2: UILabel = UILabel(frame: CGRect(x: label.center.x,y: label.center.y, width: 10, height: 10))
            let label2: UILabel = UILabel(frame: frame)
            //label2.center.x += 356.875
            //print("t1",squareSize*9-label2.frame.size.width)
            //print("t2",rect.width-label2.frame.size.width)
            label2.center.x = rect.width-label2.frame.size.width
            label2.center.y -= label2.frame.size.height
            print("label2.center",label2.center)
            label2.text = String(row)
            label2.textColor = UIColor.white
            self.addSubview(label2)
        }
        
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
                var frame: CGRect = square
                frame.origin.x = square.origin.x + square.width/7
                tst = MLWhiteKing(frame: frame)
                self.addSubview(tst)
            }
        }
        
    }
    

}
