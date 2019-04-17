//
//  FirstViewController.swift
//  MLChess
//
//  Created by Philipp Schunker on 27.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit
import PSUIKitUtils

class MainViewController: PSTimerViewController,CBChessBoardViewDataSource {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var timeLabel: UILabel!
    var chessBoardView: MLChessBoardView!
    var game: MLChessGame!
    var calcTime: Int!
    var currTime: Int!
    var stopFlag: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "MLChess"
        //self.edgesForExtendedLayout = []
        
        self.timerInterval = 1.0
        self.timerTolerance = 0.1
        self.calcTime = 60
        self.currTime = self.calcTime
        self.stopFlag = true
        
        self.setupUI()
        self.chessBoardView.dataSource = self
    }
    
    func setupUI() -> Void {
        NSLog("setupUI")
        var frame: CGRect = self.view.frame //as CGRect
        frame.size.height = frame.size.width
        //frame.size.width-=20.0
        //frame.origin.y+=CGFloat(100)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.setupNewGame))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Test", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.start))
        
        self.chessBoardView = MLChessBoardView(frame: frame)
        
        /*
        if let navBar = self.navigationController {
            // pin containerView to *bottom* of navBar view
            //board.topAnchor.constraint(equalTo: navBar.view.bottomAnchor).isActive = true
        } else {
            // pin containerView to *top* of view
            //board.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }*/
        //board.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        
        //self.view.addSubview(board)
        
        frame.size.height = self.view.frame.height
        frame.size.height += 100
        self.contentView = UIView(frame: frame)
        //self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.scrollView = UIScrollView(frame: self.view.bounds)
        //self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.isDirectionalLockEnabled = true
        self.scrollView.contentSize = self.contentView.bounds.size
        
        /*
        guard let iscrollView = self.scrollView else {
            return
        }
        guard let icontentView = self.contentView else {
            return
        }*/
        
        /*
        //var viewsDict: [String: UIView] = ["v1":iscrollView,"v2":icontentView,"v3":iboard]
        let views: [UIView] = [self.scrollView,self.contentView,self.board]
        
        self.view.addVisualConstraints(visualFormat: "H:|[v2(==v0)]|", options: NSLayoutConstraint.FormatOptions.directionLeadingToTrailing, metrics: nil, views: views)
        
        self.view.addVisualConstraints(visualFormat: "H:|[v1]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: views)
        self.view.addVisualConstraints(visualFormat: "V:|[v1]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
        
        self.scrollView.addVisualConstraints(visualFormat: "V:|[v2]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
         */
        
        self.contentView.addSubview(self.chessBoardView)
        
        let timeLabelFrame: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: frame.width, height: 44))
        self.timeLabel = UILabel(frame: timeLabelFrame)
        self.timeLabel.center = self.chessBoardView.center
        self.timeLabel.center.y += (self.chessBoardView.frame.height/2) + self.timeLabel.frame.height
        self.timeLabel.textAlignment = NSTextAlignment.center
        self.timeLabel.text = String(self.calcTime)
        self.contentView.addSubview(self.timeLabel)
        
        //let origin: CGPoint = self.chessBoardView.frame.origin
        //let buttonFrame: CGRect = CGRect(x: (origin.x+10) , y: (origin.y+100), width: 44, height: 44)
        let buttonFrame: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 44, height: 44))
        let button: PSButton = PSButton(frame: buttonFrame, color: UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1), pressedColor: UIColor(red: 0.0/255.0, green: 92.0/255.0, blue:255.0/255.0, alpha: 1))
        //let button: PSButton = PSButton(color: UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1), pressedColor: UIColor(red: 0.0/255.0, green: 92.0/255.0, blue:255.0/255.0, alpha: 1))
        button.center = self.chessBoardView.center
        button.center.y += (self.chessBoardView.frame.height/2) + button.frame.height + self.timeLabel.frame.height
        button.setTitle("Start", for: UIControl.State.normal)
        button.sizeToFit()
        button.frame.size.width += 10
        button.addTarget(self, action: #selector(self.startNewGame), for: UIControl.Event.touchUpInside)
        self.contentView.addSubview(button)
        
        self.scrollView.addSubview(self.contentView)
        self.view.addSubview(self.scrollView)
    }
    
    @objc func setupNewGame() -> Void {
        print("setupNewGame")
        /*
        if case let controller? = self.controller {
            controller.reset()
        }
        if case let board? = self.board {
            let controller: MLChessBoardViewController = MLChessBoardViewController(board)
            self.controller = controller
        }
        */
        self.game = MLChessGame()
        //self.controller?.updateView(state: game.board)
        self.chessBoardView.reloadData()
    }
    
    @objc func startNewGame() -> Void {
        self.stopFlag = !self.stopFlag
    }
    
    @objc func start() -> Void {
        self.chessBoardView.darkBackgroundColor = UIColor.blue
    }
    
    func chessBoardView(board: MLChessBoardView, chessPieceForSquare square: CBChessBoardSquare) -> CBChessBoardPiece? {
        print("chessBoardView chessPieceForSquare")
        let gamePiece: MLChessPiece? = self.game.board[square.row][square.col]
        guard let piece = gamePiece else {
            return nil
        }
        
        if piece is MLKingPiece && piece.color == MLPieceColor.black {
            return CBChessBoardPiece.BlackKing
        }
        if piece is MLKingPiece && piece.color == MLPieceColor.white {
            return CBChessBoardPiece.WhiteKing
        }
        if piece is MLQueenPiece && piece.color == MLPieceColor.black {
            return CBChessBoardPiece.BlackQueen
        }
        if piece is MLQueenPiece && piece.color == MLPieceColor.white {
            return CBChessBoardPiece.WhiteQueen
        }
        if piece is MLRookPiece && piece.color == MLPieceColor.black {
            return CBChessBoardPiece.BlackRook
        }
        if piece is MLRookPiece && piece.color == MLPieceColor.white {
            return CBChessBoardPiece.WhiteRook
        }
        if piece is MLBishopPiece && piece.color == MLPieceColor.black {
            return CBChessBoardPiece.BlackBishop
        }
        if piece is MLBishopPiece && piece.color == MLPieceColor.white {
            return CBChessBoardPiece.WhiteBishop
        }
        if piece is MLKnightPiece && piece.color == MLPieceColor.black {
            return CBChessBoardPiece.BlackKnight
        }
        if piece is MLKnightPiece && piece.color == MLPieceColor.white {
            return CBChessBoardPiece.WhiteKnight
        }
        if piece is MLPawnPiece && piece.color == MLPieceColor.black {
            return CBChessBoardPiece.BlackPawn
        }
        if piece is MLPawnPiece && piece.color == MLPieceColor.white {
            return CBChessBoardPiece.WhitePawn
        }
        
        return nil
    }
    
    override func appDidEnterBackground(notification: Notification) {
        super.appDidEnterBackground(notification: notification)
        print("appDidEnterBackground")
    }
    
    override func appWillEnterForeground(notification: Notification) {
        super.appWillEnterForeground(notification: notification)
        print("appWillEnterForeground")
    }
    
    override func startTimer() {
        super.startTimer()
        print("startTimer")
    }
    
    override func stopTimer() {
        super.stopTimer()
        print("stopTimer")
    }
    
    override func onTick(timer: Timer) {
        print(timer)
        if self.stopFlag {
            return
        }
        
        if case let label? = self.timeLabel {
            self.currTime -= 1
            if self.currTime == 0 {
                self.currTime = self.calcTime
            }
            label.text = String(self.currTime)
        }
    }

}

