//
//  MainViewController.swift
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
    var simulationColor: MLPieceColor!
    var whiteTree: MLChessTreeNode!
    var blackTree: MLChessTreeNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "MLChess"
        //self.edgesForExtendedLayout = []
        
        self.timerInterval = 1.0
        self.timerTolerance = 0.1
        self.calcTime = 30
        self.currTime = self.calcTime
        self.stopFlag = true
        
        self.treeStopFlag = false
        self.pTreeStopFlag = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        ////self.pTreeStopFlag.initialize(to: self.treeStopFlag)
        ////self.pTreeStopFlag.initialize(from: &self.treeStopFlag, count: 1)
        //self.pTreeStopFlag.initialize(to: false)
        self.pTreeStopFlag = UnsafeMutablePointer<ObjCBool>(&self.treeStopFlag)
        //print(self.pTreeStopFlag.pointee)
        //self.treeStopFlag = true
        //self.pTreeStopFlag.pointee = true
        //print(self.pTreeStopFlag.pointee)
        
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
            //startNode.nid = String(Int.random(in: 0...10000))
            print("startNode.nid",startNode.nid)
            self.mcts = MCTS(startNode, simulationCount: UInt(Int.max))
            self.mcts.simDepth = 30
            //self.mcts.debug = true
            self.mcts.pStopFlag = self.pTreeStopFlag
            self.mcts.stateDelegate = self
            
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
            //self.pTreeStopFlag.pointee = true
            self.startButton.setTitle("Start", for: UIControl.State.normal)
            return
        }
        
        self.startButton.setTitle("Stop", for: UIControl.State.normal)
        self.treeStopFlag = false
        //self.pTreeStopFlag.pointee = false
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.mcts.main()
        }
    }
    
    @objc func test() -> Void {
        self.chessBoardView.darkBackgroundColor = UIColor.blue
    }
    
    func nextMove() -> Void {
        let treeNode = self.mcts.startNode
        print("treeNode.nodes.count",treeNode.nodes.count)
        if treeNode.nodes.count == 0 {
            return
        }
        /*
        for node in treeNode.nodes {
            let cnode = node as! MLChessTreeNode
            for node in cnode.nodes {
                let ccnode = node as! MLChessTreeNode
                print("ccnode.nodes.count",ccnode.nodes.count)
                for node in ccnode.nodes {
                    let cccnode = node as! MLChessTreeNode
                    print("cccnode.nodes.count",cccnode.nodes.count)
                }
            }
        }
        */
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
        
        nextNode.nodes = NSMutableArray()
        
        if(self.game.active == MLPieceColor.white){
            self.game.active = MLPieceColor.black
            //self.whiteTree = nextNode
            //self.whiteTree.nodes = NSMutableArray()
        } else {
            self.game.active = MLPieceColor.white
            //self.blackTree = nextNode
            //self.blackTree.nodes = NSMutableArray()
        }
        
        self.mcts = MCTS(nextNode, simulationCount: UInt(Int.max))
        self.treeStopFlag = false
        self.mcts.pStopFlag = self.pTreeStopFlag
        self.mcts.stateDelegate = self
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.mcts.main()
        }
    }
    
    //MARK: - MCStateDelegate
    
    func getStateUpdates(for node: MCTreeNode, depth: UInt) -> [MCTreeNode] {
        print("getStateUpdates",node.nid)
        //print("node.denominator",node.denominator)
        print("depth",depth)
        
        if depth == 0 {
            self.simulationColor = self.game.active
            //print(self.simulationColor)
        } else {
            if self.simulationColor == MLPieceColor.white {
                self.simulationColor = MLPieceColor.black
            } else {
                self.simulationColor = MLPieceColor.white
            }
        }
        
        let simNode: MLChessTreeNode = node as! MLChessTreeNode
        var nextStates: [MLChessTreeNode] = [MLChessTreeNode]()
        //var pawnCount = 0
        for row in 0...7 {
            for col in 0...7 {
                if case let piece? = simNode.board[row][col] {
                    if piece.color == self.simulationColor {
                        //if piece is MLPawnPiece { pawnCount += 1; }
                        //if(depth == 2) { print("piece",piece.board); }
                        let states: [[[MLChessPiece?]]] = piece.getPossibleMoves(state: simNode.board, x: col, y: row)
                        for state in states {
                            let newState: MLChessTreeNode = MLChessTreeNode(board: state)
                            //newState.nid = String(Int.random(in: 0...10000))
                            print(newState.nid)
                            nextStates.append(newState)
                        }
                    }
                }
            }
        }
        
        //print("pawn count",pawnCount)
        print("state count",nextStates.count)
        
        return nextStates
    }
    
    func evaluate(_ currentNode: MCTreeNode, with simNode: MCTreeNode) -> Double {
        print("evaluate",currentNode.nid,simNode.nid)
        //print("evaluate",currentNode,simNode)
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
                self.nextMove()
            }
            label.text = String(self.currTime)
        }
    }

}

