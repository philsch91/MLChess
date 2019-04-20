//
//  FirstViewController.swift
//  MLChess
//
//  Created by Philipp Schunker on 27.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit
import PSUIKitUtils
import MonteCarloKit

class MainViewController: PSTimerViewController, CBChessBoardViewDataSource, MCStateDelegate {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var timeLabel: UILabel!
    var startButton: PSButton!
    var chessBoardView: MLChessBoardView!
    var game: MLChessGame!
    var calcTime: Int!
    var currTime: Int!
    var stopFlag: Bool!
    var mcts: MCTS!
    var treeStopFlag: ObjCBool!
    var pTreeStopFlag: UnsafeMutablePointer<ObjCBool>!
    
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
        
        self.treeStopFlag = false
        self.pTreeStopFlag = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        self.pTreeStopFlag.initialize(to: self.treeStopFlag)
        
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Test", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.test))
        
        self.chessBoardView = MLChessBoardView(frame: frame)
        
        frame.size.height = self.view.frame.height
        frame.size.height += 100
        self.contentView = UIView(frame: frame)
        
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.isDirectionalLockEnabled = true
        self.scrollView.contentSize = self.contentView.bounds.size
        
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
        button.addTarget(self, action: #selector(self.toggleGame), for: UIControl.Event.touchUpInside)
        self.contentView.addSubview(button)
        self.startButton = button
        
        self.scrollView.addSubview(self.contentView)
        self.view.addSubview(self.scrollView)
    }
    
    @objc func setupNewGame() -> Void {
        print("setupNewGame")
        
        guard self.game != nil else {
            self.game = MLChessGame()
            
            let startNode = MLChessTreeNode(board: self.game.board)
            startNode.nid = String(Int.random(in: 0...10000))
            self.mcts = MCTS(startNode, simulationCount: UInt(Int.max))
            self.mcts.pStopFlag = self.pTreeStopFlag
            
            self.chessBoardView.reloadData()
            return
        }
        
        let encoder = JSONEncoder()
        //encoder.outputFormatting = JSONEncoder.OutputFormatting.prettyPrinted
        let jsonData = try? encoder.encode(self.game)
        
        if case let json? = String(data: jsonData!, encoding: String.Encoding.utf8){
            let logManager = MLGameLogManager()
            _ = logManager.write(string: json)
        }
        
        self.game = MLChessGame()
        self.chessBoardView.reloadData()
    }
    
    @objc func toggleGame() -> Void {
        self.stopFlag = !self.stopFlag
        
        if self.stopFlag {
            self.treeStopFlag = true
            self.startButton.setTitle("Start", for: UIControl.State.normal)
            return
        }
        
        self.startButton.setTitle("Stop", for: UIControl.State.normal)
        self.treeStopFlag = false
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.mcts.main()
        }
    }
    
    @objc func test() -> Void {
        self.chessBoardView.darkBackgroundColor = UIColor.blue
    }
    
    func nextMove() -> Void {
        let treeNode = self.mcts.startNode
        if treeNode.nodes.count == 0 {
            print("treeNode.count == 0")
            return
        }
        var nextNode: MLChessTreeNode = treeNode.nodes[0] as! MLChessTreeNode
        
        for node in treeNode.nodes {
            let childNode = node as! MLChessTreeNode
            if childNode.denominator > nextNode.denominator {
                nextNode = childNode
            }
        }
        
        self.game.board = nextNode.board
        self.game.moves.append(nextNode.board)
        self.chessBoardView.reloadData()
        
        self.mcts = MCTS(nextNode, simulationCount: UInt(Int.max))
        self.mcts.pStopFlag = self.pTreeStopFlag
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.mcts.main()
        }
    }
    
    //MARK: - MCStateDelegate
    
    func getStateUpdates(for node: MCTreeNode, level: UInt) -> [MCTreeNode] {
        //if self.game.active == MLPieceColor.white { let whitePieces: [MLChessPiece?] }
        
        let simState: MLChessTreeNode = node as! MLChessTreeNode
        var nextStates: [MLChessTreeNode] = [MLChessTreeNode]()
        
        for row in 0...7 {
            for col in 0...7 {
                if case let piece? = simState.board[row][col] {
                    if piece.color == self.game.active {
                        let states: [[[MLChessPiece?]]] = piece.getPossibleMoves()
                        for cs in states {
                            let newState: MLChessTreeNode = MLChessTreeNode(board: cs)
                            newState.nid = String(Int.random(in: 0...10000))
                            nextStates.append(newState)
                        }
                    }
                }
            }
        }
        
        return nextStates
    }
    
    func evaluate(_ currentNode: MCTreeNode, with simNode: MCTreeNode) -> Double {
        let currentState: MLChessTreeNode = currentNode as! MLChessTreeNode
        let simState: MLChessTreeNode = simNode as! MLChessTreeNode
        var currentVal = 0
        var simVal = 0
        
        var kingVal = 10
        var chessMate = true
        
        if self.game.active == MLPieceColor.black {
            kingVal *= MLPieceColor.black.rawValue
        }
        
        for row in 0...7 {
            for col in 0...7 {
                if case let cpiece? = currentState.board[row][col] {
                    currentVal += cpiece.value
                }
                if case let spiece? = simState.board[row][col] {
                    simVal += spiece.value
                    if spiece.value == kingVal {
                        chessMate = false
                    }
                }
            }
        }
        
        if chessMate {
            return 1
        }
        
        let score = currentVal + simVal
        
        if self.game.active == MLPieceColor.white && score > 0 {
            return 1
        }
        
        if self.game.active == MLPieceColor.black && score < 0 {
            return 1
        }
        
        return 0
    }
    
    //MARK: - CBChessBoardViewDataSource
    
    func chessBoardView(board: MLChessBoardView, chessPieceForSquare square: CBChessBoardSquare) -> CBChessBoardPiece? {
        print("chessPieceForSquare", square.row, square.col)
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
    
    //MARK: - notifications
    
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
        //print(timer)
        if self.stopFlag {
            return
        }
        
        if case let label? = self.timeLabel {
            self.currTime -= 1
            print(String(self.currTime))
            if self.currTime == 0 {
                self.treeStopFlag = true
                self.currTime = self.calcTime
                
                if self.game.active == MLPieceColor.white {
                    self.game.active = MLPieceColor.black
                } else {
                    self.game.active = MLPieceColor.white
                }
            }
            label.text = String(self.currTime)
        }
        
        self.nextMove()
    }

}

