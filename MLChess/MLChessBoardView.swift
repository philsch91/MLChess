//
//  MLChessboard.swift
//  MLChess
//
//  Created by Philipp Schunker on 27.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit
//import CoreGraphics

class MLChessBoardView: UIView {
    
    var rect: CGRect = CGRect.null
    private var liBackgroundColor: UIColor = UIColor.white
    private var daBackgroundColor: UIColor = UIColor.darkGray
    
    var lightBackgroundColor: UIColor {
        get { return self.liBackgroundColor }
        set(newLightBackgroundColor) {
            self.liBackgroundColor = newLightBackgroundColor
            self.setNeedsDisplay()
        }
    }
    
    var darkBackgroundColor: UIColor {
        get { return self.daBackgroundColor }
        set(newDarkBackgroundColor) {
            self.daBackgroundColor = newDarkBackgroundColor
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
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
        print("origin",origin)
        let context = UIGraphicsGetCurrentContext()
        
        self.rect = CGRect(origin: origin, size: CGSize(width: squareSize, height: squareSize))
        
        //var tst: MLWhiteKingView
        
        /*
        for col in 1...8{
            let centerx: CGPoint = CGPoint(x: squareSize*CGFloat(col), y: 5)
            let framex: CGRect = CGRect(origin: centerx, size: CGSize(width: 10, height: 10))
            //----
            let labelx: UILabel = UILabel(frame: framex)
            labelx.center.x -= (labelx.frame.size.width/2)
            labelx.text="A"
            //let t = Unicode.Scalar(97+col)
            //print(t?.description)
            //labelx.text=t as? String
            labelx.textColor = UIColor.white
            self.addSubview(labelx)
 
            let labelx2: UILabel = UILabel(frame: framex)
            labelx2.center.x -= (labelx2.frame.size.width/2)
            labelx2.center.y = rect.height-labelx2.frame.size.width
            labelx2.text = "A"
            labelx2.textColor = UIColor.white
            self.addSubview(labelx2)
        }
        */
        for row in 1...8 {
            let centerx: CGPoint = CGPoint(x: squareSize*CGFloat(row), y: 5)
            let framex: CGRect = CGRect(origin: centerx, size: CGSize(width: 10, height: 10))
            //----
            let labelx: UILabel = UILabel(frame: framex)
            labelx.center.x -= (labelx.frame.size.width/2)
            //labelx.text=String(row)
            labelx.text = String(format: "%c", row+64) //as String
            //labelx.text = String(UnicodeScalar(row+64)!.value)
            //labelx.text=String(UnicodeScalar(row + 64))
            labelx.textColor = UIColor.white
            self.addSubview(labelx)
            
            let labelx2: UILabel = UILabel(frame: framex)
            labelx2.center.x -= (labelx2.frame.size.width/2)
            labelx2.center.y = rect.height-labelx2.frame.size.height
            labelx2.text = String(format: "%c", row+64)
            labelx2.textColor = UIColor.white
            self.addSubview(labelx2)
            
            //let center: CGPoint = CGPoint(x: 5, y: rect.height-(squareSize*CGFloat(row))-20)
            let center: CGPoint = CGPoint(x: 5, y: squareSize*CGFloat(row))
            //print("center",center)
            //let frame: CGRect = CGRect(x: 5, y: squareSize*CGFloat(row), width: 10, height: 10)
            let frame: CGRect = CGRect(origin: center, size: CGSize(width: 10, height: 10))
            //----
            let label: UILabel = UILabel(frame: frame)  //(10.0, 46.875)
            //label.layer.borderWidth=1     //debug
            //print("label.center",label.center)
            label.center.y -= (label.frame.size.height)     //(10.0, 36.875)
            //print("label.center",label.center)
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
            //print("label2.center",label2.center)
            label2.text = String(row)
            label2.textColor = UIColor.white
            self.addSubview(label2)
        }
        
        for row in 0...7 {
            for col in 0...7{
                let square = CGRect(x: origin.x+(CGFloat(col)*squareSize), y: origin.y-(CGFloat(row)*squareSize), width: squareSize, height: squareSize)
                //print(square.origin)
                
                if (row+col)%2 == 0{
                    //print("row ",row," col ",col," white")
                    context?.setFillColor(self.liBackgroundColor.cgColor)
                } else {
                    //print("row ",row," col ",col," black")
                    context?.setFillColor(self.daBackgroundColor.cgColor)
                }
                
                context?.fill(square)
                /*
                if row == 0 && col == 0 {
                    tst = MLWhiteKingView(frame: square)
                    tst.center = CGPoint(x: square.origin.x+(square.size.width/2), y: square.origin.y+(square.size.height/2))
                    //print(tst.center)
                    print(row,col,square.origin,square.size,tst.center)
                    tst.center.x += 3
                    self.addSubview(tst)
                }
                */
            }
        }
        
    }

}
