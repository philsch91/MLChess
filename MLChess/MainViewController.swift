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
    let calcTime: Int = 30
    let coolDownTime: Int = 3
    var currTime: Int!
    var currCoolDownTime: Int!
    var stopFlag: Bool!
    var mcts: MCTS!
    var treeStopFlag: ObjCBool!
    var pTreeStopFlag: UnsafeMutablePointer<ObjCBool>!
    var simulationColor: MLPieceColor!
    var whiteTree: MLChessTreeNode!
    var blackTree: MLChessTreeNode!
    var simMode: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "MLChess"
        //self.edgesForExtendedLayout = []
        
        self.timerInterval = 1.0
        self.timerTolerance = 0.1
        self.currTime = self.calcTime
        self.currCoolDownTime = 0
        self.stopFlag = true
        
        self.treeStopFlag = false
        //self.pTreeStopFlag = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        ////self.pTreeStopFlag.initialize(to: self.treeStopFlag)
        ////self.pTreeStopFlag.initialize(from: &self.treeStopFlag, count: 1)
        ////self.pTreeStopFlag.initialize(to: false)
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
        
        let saveButtonItem  = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.saveGame))
        //let testButtonItem = UIBarButtonItem(title: "Test", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.test))
        
        self.navigationItem.rightBarButtonItems = [saveButtonItem]
        
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
        
        if self.game != nil {
            print("save game")
            self.saveGame()
        }
        
        //guard self.game != nil else {}
        self.game = MLChessGame()
        let startNode = MLChessTreeNode(board: self.game.board, color: MLPieceColor.white)
        //startNode.nid = String(Int.random(in: 0...10000))
        print("startNode.nid",startNode.nid)
        self.mcts = MCTS(startNode, simulationCount: UInt(Int.max))
        //self.mcts.simDepth = 60
        //self.mcts.debug = true
        self.mcts.pStopFlag = self.pTreeStopFlag
        self.mcts.stateDelegate = self
            
        self.chessBoardView.reloadData()
    }
    
    @objc func saveGame() -> Void {
        /*
        var games: [MLChessGame]!
        
        let logManager = MLGameLogManager()
        let str = logManager.read()
        
        if str == "" {
            print("empty")
            games = [MLChessGame]()
        } else {
            let decoder = JSONDecoder()
            let json = str.data(using: String.Encoding.utf8)!
            games = try? decoder.decode([MLChessGame].self, from: json)
        }
        
        games.append(self.game)
        
        let encoder = JSONEncoder()
        //encoder.outputFormatting = JSONEncoder.OutputFormatting.prettyPrinted
        //let jsonData = try? encoder.encode(self.game)
        let jsonData = try? encoder.encode(games)
        
        if let json = String(data: jsonData!, encoding: String.Encoding.utf8){
            _ = logManager.clear()
            _ = logManager.write(string: json)
        }
        */
        
        let logManager = MLGameLogManager()
        logManager.save(game: self.game)
    }
    
    @objc func toggleGame() -> Void {
        self.stopFlag = !self.stopFlag
        
        if self.stopFlag {
            self.treeStopFlag = true
            //self.pTreeStopFlag.pointee = true
            self.startButton.setTitle("Start", for: UIControl.State.normal)
            return
        }
        
        if(self.game == nil){
            self.setupNewGame()
        }
        
        self.treeStopFlag = false
        //self.pTreeStopFlag.pointee = false
        self.startButton.setTitle("Stop", for: UIControl.State.normal)
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.mcts.main()
        }
    }
    
    @objc func test() -> Void {
        self.chessBoardView.darkBackgroundColor = UIColor.blue
    }
    
    func handleGameEnd() -> Void {
        self.toggleGame()
        var msg = "white lost"
        if self.game.active == MLPieceColor.black {
            msg = "black lost"
        }
        let alert = UIAlertController(title: "Chess mate", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "New game", style: UIAlertAction.Style.default, handler: { _ in
            self.setupNewGame()
            self.toggleGame()
        }))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            NSLog("user pressed OK")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func nextMove() -> Void {
        let treeNode = self.mcts.startNode
        print("treeNode.nodes.count",treeNode.nodes.count)
        if treeNode.nodes.count == 0 {
            self.handleGameEnd()
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
        var states: [MLChessTreeNode] = [MLChessTreeNode]()
        //Int.random(in: 0...10000)
        for node in treeNode.nodes {
            let childNode = node as! MLChessTreeNode
            print("node.numerator",childNode.numerator,"node.denominator",childNode.denominator)
            if childNode.denominator >= nextNode.denominator {
                //nextNode = childNode
                if childNode.numerator >= nextNode.numerator {
                    print("add",childNode.nid)
                    nextNode = childNode
                    if !states.contains(childNode) {
                        states.append(childNode)
                    }
                }
            }
        }
        //print(states.count)
        nextNode = states[Int.random(in: 0..<states.count)]
        
        self.game.board = nextNode.board
        self.game.moves.append(nextNode.board)
        self.chessBoardView.reloadData()
        
        nextNode.nodes = NSMutableArray()
        self.mcts = nil
        
        if(self.game.active == MLPieceColor.white){
            self.whiteTree = nextNode
            self.game.active = MLPieceColor.black
        } else {
            self.blackTree = nextNode
            self.game.active = MLPieceColor.white
        }
        
        print("active player", self.game.active)
    }
    
    func startSearch() -> Void {
        var nextNode: MCTreeNode!
        if(self.game.active == MLPieceColor.white){
            nextNode = self.blackTree
        } else {
            nextNode = self.whiteTree
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
        //print("getStateUpdates",node.nid)
        //print("node.denominator",node.denominator)
        //print("depth",depth)
        
        if depth > 60 {
            return [MLChessTreeNode]()
        }
        /*
        var parentCount = 0
        var parentNode: MCTreeNode? = node.parent
        while let pnode = parentNode {
            parentNode = pnode.parent
            parentCount += 1
        }
        print("parents",parentCount)
        */
        
        let simNode: MLChessTreeNode = node as! MLChessTreeNode
        var possibleStates: [[[MLChessPiece?]]] = [[[MLChessPiece?]]]()
        //var pawnCount = 0
        
        for row in 0...7 {
            for col in 0...7 {
                if let piece = simNode.board[row][col] {
                    if piece.color == simNode.color {
                        //if piece is MLPawnPiece { pawnCount += 1; }
                        let moves: [[[MLChessPiece?]]] = piece.getPossibleMoves(state: simNode.board, x: col, y: row)
                        for move in moves {
                            //let node: MLChessTreeNode = MLChessTreeNode(board: state)
                            //node.nid = String(Int.random(in: 0...10000))
                            //print(node.nid)
                            //stateNodes.append(node)
                            possibleStates.append(move)
                        }
                    }
                }
            }
        }
        
        //print("pawn count",pawnCount)
        var states: [[[MLChessPiece?]]] = possibleStates
        
        if self.game.moves.count > 50 {
            states = [[[MLChessPiece?]]]()
            for istate in possibleStates {
                for jstate in self.game.moves {
                    //if !istate.elementsEqual(jstate)
                    if istate != jstate {
                        states.append(istate)
                    }
                }
            }
        }
        
        let childNodeColor: MLPieceColor
        
        if simNode.color == MLPieceColor.white {
            childNodeColor = MLPieceColor.black
        } else {
            childNodeColor = MLPieceColor.white
        }
        
        var stateNodes: [MLChessTreeNode] = [MLChessTreeNode]()
        
        for state in states {
            //stateNodes.append(MLChessTreeNode(board: state, color: childNodeColor))
            
            var isValidState = true
            for row in 0...7 {
                for col in 0...7 {
                    if let piece = state[row][col] {
                        if piece.color != childNodeColor {
                            continue
                        }
                        let moves: [[[MLChessPiece?]]] = piece.getPossibleMoves(state: state, x: col, y: row)
                        //proof that chessmate is not possible for all moves of the curr.piece
                        for move in moves {
                            var chessMate = true
                            for irow in 0...7 {
                                for icol in 0...7 {
                                    if let ipiece = move[irow][icol] {
                                        if ipiece is MLKingPiece && ipiece.color == simNode.color {
                                                chessMate = false
                                        }
                                    }
                                }
                            }
                            //one chessmate move invalidates the state
                            if chessMate {
                                isValidState = false
                            }
                            //if !chessMate {stateNodes.append(MLChessTreeNode(board: state, color: childNodeColor))}
                        }
                    }
                }
            }
            
            if isValidState {
                stateNodes.append(MLChessTreeNode(board: state, color: childNodeColor))
            }
            
        }
        
        //print("state count",stateNodes.count)
        
        return stateNodes
    }
    
    func evaluate(_ currentNode: MCTreeNode, with simNode: MCTreeNode) -> Double {
        //print("evaluate",currentNode.nid,simNode.nid)
        //print("evaluate",currentNode,simNode)
        let currentState: MLChessTreeNode = currentNode as! MLChessTreeNode
        let simState: MLChessTreeNode = simNode as! MLChessTreeNode
        var currentVal = 0
        var simVal = 0
        
        var kingVal = 10
        var chessMate = true
        
        if self.game.active == MLPieceColor.white {
            kingVal *= MLPieceColor.black.rawValue
        }
        
        for row in 0...7 {
            for col in 0...7 {
                if let cpiece = currentState.board[row][col] {
                    currentVal += cpiece.value
                }
                if let spiece = simState.board[row][col] {
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
        //print("score", score)
        
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
    
    //MARK: - TimerViewController
    
    override func onTick(timer: Timer) {
        //print(timer)
        if self.stopFlag {
            return
        }
        
        if self.currCoolDownTime > 0 {
            self.currCoolDownTime -= 1
            print("cool down",self.currCoolDownTime)
            if self.currCoolDownTime == 0 {
                self.startSearch()
            }
            return
        }
        
        self.currTime -= 1
        print(String(self.currTime))
        
        if self.currTime == 0 {
            self.treeStopFlag = true
            self.currCoolDownTime = self.coolDownTime
            self.currTime = self.calcTime
            self.nextMove()
        }
        
        self.timeLabel.text = String(self.currTime)
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
}

