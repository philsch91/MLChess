//
//  CBChessBoardView.swift
//  MLChess
//
//  Created by Philipp Schunker on 27.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit
//import CoreGraphics

class CBChessBoardView: UIView {
    
    var rect: CGRect = CGRect.null
    private var subViews: [UIView]
    private var liBackgroundColor: UIColor = UIColor.white
    private var daBackgroundColor: UIColor = UIColor.darkGray
    
    weak var dataSource: CBChessBoardViewDataSource?
    weak var delegate: CBChessBoardViewDelegate?
    
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
        self.subViews = [UIView]()
        super.init(frame: frame)
        self.backgroundColor = UIColor.brown
    }
    
    required init?(coder decoder: NSCoder) {
        self.subViews = [UIView]()
        super.init(coder: decoder)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //print(rect)
        //CoreGraphics = LLO
        //A lower-left-origin coordinate system (LLO), in which the origin of drawing operations is at the lower-left
        //corner of the drawing area, with positive values extending upward and to the right.
        //The default coordinate system used by Core Graphics framework is LLO-based
        
        //UIKit = ULO
        //An upper-left-origin coordinate system (ULO), in which the origin of drawing operations is at the upper-left
        //corner of the drawing area, with positive values extending downward and to the right.
        //The default coordinate system used by the UIKit and Core Animation frameworks is ULO-based
        //https://developer.apple.com/library/archive/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/GraphicsDrawingOverview/GraphicsDrawingOverview.html
        
        let squareSize: CGFloat = (rect.width-40)/8
        print("squareSize",squareSize)
        let origin = CGPoint(x: 20, y: rect.height-squareSize-20)
        print("origin",origin)
        let context = UIGraphicsGetCurrentContext()
        
        self.rect = CGRect(origin: origin, size: CGSize(width: squareSize, height: squareSize))
        
        //var tst: MLWhiteKingView
        
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
            let centerx: CGPoint = CGPoint(x: squareSize*CGFloat(row), y: 6)
            let framex: CGRect = CGRect(origin: centerx, size: CGSize(width: 12, height: 12))
            //----
            let labelx: UILabel = UILabel(frame: framex)
            labelx.center.x -= (labelx.frame.size.width/2)
            labelx.center.y = 10
            //labelx.text = String(row)
            labelx.text = String(format: "%c", row+64) //as String
            //labelx.text = String(UnicodeScalar(row+64)!.value)
            //labelx.text = String(UnicodeScalar(row + 64))
            labelx.textColor = UIColor.white
            self.addSubview(labelx)
            
            let labelx2: UILabel = UILabel(frame: framex)
            labelx2.center.x -= (labelx2.frame.size.width/2)    //labelx2.center.x = 6
            //labelx2.center.y = rect.height-labelx2.frame.size.height
            labelx2.center.y = rect.height-10
            labelx2.text = String(format: "%c", row+64)
            labelx2.textColor = UIColor.white
            self.addSubview(labelx2)
            
            //let center: CGPoint = CGPoint(x: 5, y: rect.height-(squareSize*CGFloat(row)))     //LLO
            let center: CGPoint = CGPoint(x: 6, y: squareSize*CGFloat(row))
            //print("center",center)
            //let frame: CGRect = CGRect(x: 5, y: squareSize*CGFloat(row), width: 10, height: 10)
            let frame: CGRect = CGRect(origin: center, size: CGSize(width: 12, height: 12))
            //----
            let labely: UILabel = UILabel(frame: frame)  //(10.0, 46.875)
            //labely.layer.borderWidth=1     //debug
            labely.center.x = 10
            //print("labely.center",labely.center)
            labely.center.y -= (labely.frame.size.height/2)     //(10.0, 36.875)
            //print("labely.center",labely.center)
            labely.text = String(9-row)
            labely.textColor = UIColor.white
            self.addSubview(labely)
            
            //let labely2: UILabel = UILabel(frame: CGRect(x: label.center.x,y: label.center.y, width: 10, height: 10))
            let labely2: UILabel = UILabel(frame: frame)
            //labely2.center.x += 356.875
            //print("t1",squareSize*9-labely2.frame.size.width)
            //print("t2",rect.width-labely2.frame.size.width)
            //labely2.center.x = rect.width-(labely2.frame.size.width)
            //labely2.center.x = rect.width-20+(labely2.frame.size.width)
            labely2.center.x = rect.width-10
            labely2.center.y -= (labely2.frame.size.height/2)
            //print("labely2.center",labely2.center)
            labely2.text = String(9-row)
            labely2.textColor = UIColor.white
            self.addSubview(labely2)
        }
    }
    
    public func reloadData() -> Void {
        guard let dataSource = self.dataSource else {
            return
        }
        
        var state: [[CBChessBoardPiece?]] = [[CBChessBoardPiece?]]()
        var square: CBChessBoardSquare!
        var index: Int = 0
        
        for _ in 0...7 {
            var row: [CBChessBoardPiece?] = [CBChessBoardPiece?]()
            for _ in 0...7 {
                square = CBChessBoardSquare(index)
                
                let boardPiece: CBChessBoardPiece? = dataSource.chessBoardView(board: self, chessPieceForSquare: square)
                
                if case let piece? = boardPiece {
                    row.append(piece)
                } else {
                    row.append(nil)
                }
                
                index += 1
            }
            state.append(row)
        }
        
        self.updateView(state: state)
    }
    
    func updateView(state: [[CBChessBoardPiece?]]) -> Void {
        print("updateView")
        self.reset()
        var frame: CGRect = self.rect
        //41,875
        for row in 0...7 {
            for col in 0...7 {
                if case let piece? = state[row][col] {
                    //if piece is MLKingPiece && piece.color == MLPieceColor.black {
                    if piece == CBChessBoardPiece.BlackKing {
                        print(row,col,"king")
                        print(frame)
                        let fig = CBBlackKingView(frame: frame)
                        fig.center = CGPoint(x: frame.origin.x+(frame.size.width/2), y: frame.origin.y+(frame.size.height/2))
                        print(row,col,fig.frame.origin,fig.frame.size)
                        //fig.center.x += 3     //correction not needed with textalignment=NSTextAlignment.center
                        self.addSubview(fig)
                        self.subViews.append(fig)
                    }
                    //if piece is MLKingPiece && piece.color == MLPieceColor.white {
                    if piece == CBChessBoardPiece.WhiteKing {
                        print(row,col,"king")
                        print(frame)
                        let fig = CBWhiteKingView(frame: frame)
                        fig.center = CGPoint(x: frame.origin.x+(frame.size.width/2), y: frame.origin.y+(frame.size.height/2))
                        print(row,col,fig.frame.origin,fig.frame.size)
                        self.addSubview(fig)
                        self.subViews.append(fig)
                    }
                    if piece == CBChessBoardPiece.BlackQueen {
                        let fig = CBBlackQueenView(frame: frame)
                        fig.center = CGPoint(x: frame.origin.x+(frame.size.width/2), y: frame.origin.y+(frame.size.height/2))
                        print(row,col,fig.frame.origin,fig.frame.size)
                        //fig.center.x += 3
                        self.addSubview(fig)
                        self.subViews.append(fig)
                    }
                    if piece == CBChessBoardPiece.WhiteQueen {
                        let fig = CBWhiteQueenView(frame: frame)
                        fig.center = CGPoint(x: frame.origin.x+(frame.size.width/2), y: frame.origin.y+(frame.size.height/2))
                        print(row,col,fig.frame.origin,fig.frame.size)
                        //fig.center.x += 3
                        self.addSubview(fig)
                        self.subViews.append(fig)
                    }
                    if piece == CBChessBoardPiece.BlackRook {
                        let fig = CBBlackRookView(frame: frame)
                        fig.center = CGPoint(x: frame.origin.x+(frame.size.width/2), y: frame.origin.y+(frame.size.height/2))
                        print(row,col,fig.frame.origin,fig.frame.size)
                        //fig.center.x += 3
                        self.addSubview(fig)
                        self.subViews.append(fig)
                    }
                    if piece == CBChessBoardPiece.WhiteRook {
                        let fig = CBWhiteRookView(frame: frame)
                        fig.center = CGPoint(x: frame.origin.x+(frame.size.width/2), y: frame.origin.y+(frame.size.height/2))
                        print(row,col,fig.frame.origin,fig.frame.size)
                        //fig.center.x += 3
                        self.addSubview(fig)
                        self.subViews.append(fig)
                    }
                    if piece == CBChessBoardPiece.BlackBishop {
                        let fig = CBBlackBishopView(frame: frame)
                        fig.center = CGPoint(x: frame.origin.x+(frame.size.width/2), y: frame.origin.y+(frame.size.height/2))
                        print(row,col,fig.frame.origin,fig.frame.size)
                        //fig.center.x += 3
                        self.addSubview(fig)
                        self.subViews.append(fig)
                    }
                    if piece == CBChessBoardPiece.WhiteBishop {
                        let fig = CBWhiteBishopView(frame: frame)
                        fig.center = CGPoint(x: frame.origin.x+(frame.size.width/2), y: frame.origin.y+(frame.size.height/2))
                        print(row,col,fig.frame.origin,fig.frame.size)
                        //fig.center.x += 3
                        self.addSubview(fig)
                        self.subViews.append(fig)
                    }
                    if piece == CBChessBoardPiece.BlackKnight {
                        let fig = CBBlackKnightView(frame: frame)
                        fig.center = CGPoint(x: frame.origin.x+(frame.size.width/2), y: frame.origin.y+(frame.size.height/2))
                        print(row,col,fig.frame.origin,fig.frame.size)
                        //fig.center.x += 3
                        self.addSubview(fig)
                        self.subViews.append(fig)
                    }
                    if piece == CBChessBoardPiece.WhiteKnight {
                        let fig = CBWhiteKnightView(frame: frame)
                        fig.center = CGPoint(x: frame.origin.x+(frame.size.width/2), y: frame.origin.y+(frame.size.height/2))
                        print(row,col,fig.frame.origin,fig.frame.size)
                        //fig.center.x += 3
                        self.addSubview(fig)
                        self.subViews.append(fig)
                    }
                    if piece == CBChessBoardPiece.BlackPawn {
                        let fig = CBBlackPawnView(frame: frame)
                        fig.center = CGPoint(x: frame.origin.x+(frame.size.width/2), y: frame.origin.y+(frame.size.height/2))
                        print(row,col,fig.frame.origin,fig.frame.size)
                        //fig.center.x += 3
                        self.addSubview(fig)
                        self.subViews.append(fig)
                    }
                    if piece == CBChessBoardPiece.WhitePawn {
                        let fig = CBWhitePawnView(frame: frame)
                        fig.center = CGPoint(x: frame.origin.x+(frame.size.width/2), y: frame.origin.y+(frame.size.height/2))
                        print(row,col,fig.frame.origin,fig.frame.size)
                        //fig.center.x += 3
                        self.addSubview(fig)
                        self.subViews.append(fig)
                    }
                }
                frame.origin.x += frame.size.width
            }
            frame.origin.x = self.rect.origin.x
            frame.origin.y -= frame.size.height
        }
    }
    
    func reset() -> Void {
        print("reset")
        for view in self.subViews {
            view.removeFromSuperview()
        }
    }

}
