//
//  MLMainViewController.swift
//  MLChess
//
//  Created by Philipp Schunker on 27.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit
import PSUIKitUtils
import MonteCarloKit

class MLMainViewController: PSTimerViewController, CBChessBoardViewDataSource, CBChessBoardViewDelegate, MCStateDelegate {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var timeLabel: UILabel!
    var selectionLabel: UILabel!
    var moveLabel: UILabel!
    var startButton: PSButton!
    var chessBoardView: CBChessBoardView!
    
    var game: MLChessGame!
    
    var calcTime: Int = 40
    let coolDownTime: Int = 3
    var currTime: Int!
    var currCoolDownTime: Int!
    
    var stopFlag: Bool!
    var mcts: MCTS!
    var treeStopFlag: ObjCBool!
    var pTreeStopFlag: UnsafeMutablePointer<ObjCBool>!
    var simulationColor: MLPieceColor!
    var simulationDepth: Int!
    var whiteTree: MLChessTreeNode!
    var blackTree: MLChessTreeNode!
    
    var isTestModeEnabled: Bool!
    var isSimModeEnabled: Bool!
    var userColor: MLPieceColor!
    var whiteStrategy: MLChessStrategy!
    var blackStrategy: MLChessStrategy!
    var whiteSimulationDepth: Int!
    var blackSimulationDepth: Int!
    var whiteCalculationDuration: Int!
    var blackCalculationDuration: Int!
    var whiteStateEvaluation: MLChessStateEvaluation!
    var blackStateEvaluation: MLChessStateEvaluation!
    
    var evaluationCount: Int!
    
    var srcPos: CBChessBoardSquare?
    var desPos: CBChessBoardSquare?
    
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
        self.chessBoardView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isTestModeEnabled = UserDefaults.standard.bool(forKey: "testMode")
        print("testMode",self.isTestModeEnabled)
        
        self.isSimModeEnabled = UserDefaults.standard.bool(forKey: "simulationMode")
        print("simulationMode",self.isSimModeEnabled)
        
        self.userColor = MLPieceColor(rawValue: UserDefaults.standard.integer(forKey: "userColor"))
        print("userColor",self.userColor)
        
        self.whiteStrategy = MLChessStrategy(rawValue: UserDefaults.standard.integer(forKey: "whiteStrategy"))
        print("whiteStrategy",self.whiteStrategy)
        
        self.blackStrategy = MLChessStrategy(rawValue: UserDefaults.standard.integer(forKey: "blackStrategy"))
        print("blackStrategy",self.blackStrategy)
        
        self.whiteSimulationDepth = UserDefaults.standard.integer(forKey: "whiteSimulationDepth")
        print("whiteSimulationDepth",self.whiteSimulationDepth)
        
        self.blackSimulationDepth = UserDefaults.standard.integer(forKey: "blackSimulationDepth")
        print("blackSimulationDepth",self.blackSimulationDepth)
        
        self.whiteCalculationDuration = UserDefaults.standard.integer(forKey: "whiteCalcDuration")
        print("whiteCalcDuration",self.whiteCalculationDuration)
        
        self.blackCalculationDuration = UserDefaults.standard.integer(forKey: "blackCalcDuration")
        print("blackCalcDuration",self.blackCalculationDuration)
        
        self.whiteStateEvaluation = MLChessStateEvaluation(rawValue: UserDefaults.standard.integer(forKey: "whiteStateEvaluation"))
        print("whiteStateEvaluation",self.whiteStateEvaluation)
        
        self.blackStateEvaluation = MLChessStateEvaluation(rawValue: UserDefaults.standard.integer(forKey: "blackStateEvaluation"))
        print("blackStateEvaluation",self.blackStateEvaluation)
        
        self.timeLabel.text = String(self.whiteCalculationDuration)
    }
    
    func setupUI() -> Void {
        NSLog("setupUI")
        self.view.backgroundColor = UIColor.white
        var frame: CGRect = self.view.frame //as CGRect
        frame.size.height = frame.size.width
        //frame.size.width-=20.0
        //frame.origin.y+=CGFloat(100)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.setupNewGame))
        
        let saveButtonItem  = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.saveGame))
        //let testButtonItem = UIBarButtonItem(title: "Test", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.test))
        self.navigationItem.rightBarButtonItems = [saveButtonItem]
        
        self.chessBoardView = CBChessBoardView(frame: frame)
        
        frame.size.height = self.view.frame.height
        frame.size.height += 100
        self.contentView = UIView(frame: frame)
        
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.isDirectionalLockEnabled = true
        self.scrollView.contentSize = self.contentView.bounds.size
        
        self.contentView.addSubview(self.chessBoardView)
        
        let timeLabelFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: frame.width, height: 44))
        self.timeLabel = UILabel(frame: timeLabelFrame)
        self.timeLabel.center = self.chessBoardView.center
        self.timeLabel.center.y += (self.chessBoardView.frame.height/2) + self.timeLabel.frame.height
        self.timeLabel.textAlignment = NSTextAlignment.center
        self.timeLabel.text = String(self.calcTime)
        
        self.contentView.addSubview(self.timeLabel)
        
        let selectionLabelFrame = CGRect(x: 0, y: 0, width: 44, height: 44)
        self.selectionLabel = UILabel(frame: selectionLabelFrame)
        self.selectionLabel.center = self.timeLabel.center
        self.selectionLabel.center.x -= 44
        self.selectionLabel.center.y += 44
        
        self.contentView.addSubview(self.selectionLabel)
        
        let moveLabelFrame = CGRect(x: 0, y: 0, width: 44, height: 44)
        self.moveLabel = UILabel(frame: moveLabelFrame)
        self.moveLabel.center = self.timeLabel.center
        self.moveLabel.center.x += 44 + self.moveLabel.frame.width
        self.moveLabel.center.y += 44
        
        self.contentView.addSubview(self.moveLabel)
        
        //let origin: CGPoint = self.chessBoardView.frame.origin
        //let buttonFrame: CGRect = CGRect(x: (origin.x+10) , y: (origin.y+100), width: 44, height: 44)
        let buttonFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 44, height: 44))
        let button = PSButton(frame: buttonFrame, color: UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1), pressedColor: UIColor(red: 0.0/255.0, green: 92.0/255.0, blue:255.0/255.0, alpha: 1))
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
        self.evaluationCount = 0
        self.simulationDepth = self.whiteSimulationDepth
        self.currTime = self.whiteCalculationDuration
        
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
        if self.isSimModeEnabled {
            //pause game
        }
        
        self.toggleGame()
        
        var msg = "chess mate - white lost"
        var winnerId = -1
        
        if self.game.active == MLPieceColor.black {
            msg = "chess mate - black lost"
            winnerId = 1
        }
        
        if self.checkRemis() {
            msg = "remis"
            winnerId = 0
        }
        
        self.game.winner = winnerId
        
        let alert = UIAlertController(title: "Game End", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertAction.Style.default, handler: { _ in
            self.setupNewGame()
            self.toggleGame()
        }))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            NSLog("user pressed OK")
        }))
        
        if winnerId == 0 {
            alert.addAction(UIAlertAction(title: "Continue Game", style: UIAlertAction.Style.default, handler: { _ in
                self.startSearch()
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func nextMove() -> Void {
        self.evaluationCount = 0
        let treeNode = self.mcts.startNode
        print("treeNode.nodes.count",treeNode.nodes.count)
        
        if treeNode.nodes.count == 0 {
            self.handleGameEnd()
            return
        }
        /*
        for node in treeNode.nodes {
            let cnode = node as! MLChessTreeNode
            print(cnode)
            /*
            for node in cnode.nodes {
                let ccnode = node as! MLChessTreeNode
                print("ccnode.nodes.count",ccnode.nodes.count)
                for node in ccnode.nodes {
                    let cccnode = node as! MLChessTreeNode
                    print("cccnode.nodes.count",cccnode.nodes.count)
                }
            }
            */
        }
        */
        
        let strategy: MLChessStrategy!
        
        if self.game.active == MLPieceColor.white {
            strategy = self.whiteStrategy
        } else {
            strategy = self.blackStrategy
        }
        
        print(strategy)
        
        //var nextNode: MLChessTreeNode = treeNode.nodes[0] as! MLChessTreeNode
        var strategyNodes: [MLChessTreeNode] = [MLChessTreeNode]()
        
        var bestNumerator: Double = 0
        var bestDenominator: Double = 0
        
        //Int.random(in: 0...10000)
        for node in treeNode.nodes {
            let childNode = node as! MLChessTreeNode
            //print("node.numerator",childNode.numerator,"node.denominator",childNode.denominator)
            if childNode.numerator > bestNumerator {
                bestNumerator = childNode.numerator
            }
            
            if childNode.denominator > bestDenominator {
                bestDenominator = childNode.denominator
            }
        }
        
        print("best numerator",bestNumerator)
        print("best denominator",bestDenominator)
        
        for node in treeNode.nodes {
            let childNode = node as! MLChessTreeNode
            //print("node.numerator",childNode.numerator,"node.denominator",childNode.denominator)
            if strategy == MLChessStrategy.Denominator {
                if childNode.denominator == bestDenominator {
                    //nextNode = childNode
                    /*
                    if childNode.numerator == bestNumerator {
                        //print("add",childNode.nid)
                        //nextNode = childNode
                        if !strategyNodes.contains(childNode) {
                            strategyNodes.append(childNode)
                        }
                    }*/
                    if !strategyNodes.contains(childNode) {
                        strategyNodes.append(childNode)
                    }
                }
            } else {
                if childNode.numerator == bestNumerator {
                    //nextNode = childNode
                    /*
                    if childNode.denominator == bestDenominator {
                        //print("add",childNode.nid)
                        //nextNode = childNode
                        if !strategyNodes.contains(childNode) {
                            strategyNodes.append(childNode)
                        }
                    } */
                    if !strategyNodes.contains(childNode) {
                        strategyNodes.append(childNode)
                    }
                }
            }
        }
        
        var nextNode: MLChessTreeNode = strategyNodes[0]
        var nodes: [MLChessTreeNode] = [MLChessTreeNode]()
        bestNumerator = nextNode.numerator
        bestDenominator = nextNode.denominator
        
        for node in strategyNodes {
            if strategy == MLChessStrategy.Denominator {
                if node.numerator > bestNumerator {
                    bestNumerator = node.numerator
                }
            } else {
                if node.denominator > bestDenominator {
                    bestDenominator = node.denominator
                }
            }
        }
        
        for node in strategyNodes {
            if strategy == MLChessStrategy.Denominator {
                if node.numerator == bestNumerator {
                    nodes.append(node)
                }
            } else {
                if node.denominator == bestDenominator {
                    nodes.append(node)
                }
            }
        }
        
        print("states.count",nodes.count)
        nextNode = nodes[Int.random(in: 0..<nodes.count)]
        print("nextNode.nodes.count",nextNode.nodes.count)
        //print("nextNode.nid",nextNode.nid)
        
        self.game.board = nextNode.board
        self.game.moves.append(nextNode.board)
        //update view
        self.chessBoardView.reloadData()
        
        nextNode.nodes = NSMutableArray()
        
        if nextNode.numerator == Double.infinity && nextNode.denominator == Double.infinity {
            nextNode.numerator = Double(0)
            nextNode.denominator = Double(0)
        }
        
        self.mcts = nil
        
        if self.game.active == MLPieceColor.white {
            self.whiteTree = nextNode
            self.game.active = MLPieceColor.black
            self.simulationDepth = self.blackSimulationDepth
            self.currTime = self.blackCalculationDuration
        } else {
            self.blackTree = nextNode
            self.game.active = MLPieceColor.white
            self.simulationDepth = self.whiteSimulationDepth
            self.currTime = self.whiteCalculationDuration
        }
        
        let isRemis = self.checkRemis()
        
        if isRemis {
            self.handleGameEnd()
            return
        }
        
        print("is remis",isRemis)
        print("active player",self.game.active)
    }
    
    func startSearch() -> Void {
        var nextNode: MCTreeNode!
        if self.game.active == MLPieceColor.white {
            nextNode = self.blackTree
        } else {
            nextNode = self.whiteTree
        }
        
        print("newRootNode.numerator",nextNode.numerator)
        print("newRootNode.denominator",nextNode.denominator)
        
        self.mcts = MCTS(nextNode, simulationCount: UInt(Int.max))
        self.treeStopFlag = false
        self.mcts.pStopFlag = self.pTreeStopFlag
        self.mcts.stateDelegate = self
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.mcts.main()
        }
    }
    
    func checkRemis() -> Bool {
        let moveCount = self.game.moves.count
        
        if moveCount < 50 {
            return false
        }
        
        var score = 0
        
        let lstate = self.game.moves[moveCount-1]
        for row in 0...7 {
            for col in 0...7 {
                if let piece = lstate[row][col] {
                    if piece.value != 1 && piece.value != 10
                        && piece.value != -1 && piece.value != -10 {
                        return false
                    }
                    score += piece.value
                }
            }
        }
        
        for i in ((moveCount-50)...(moveCount-2)).reversed() {
            var cscore = 0
            let state = self.game.moves[i]
            
            for row in 0...7 {
                for col in 0...7 {
                    if let piece = state[row][col] {
                        cscore += piece.value
                    }
                }
            }
            
            if cscore != score {
                return false
            }
        }
        
        return true
    }
    
    //MARK: - MCStateDelegate
    
    func getStateUpdates(for node: MCTreeNode, depth: UInt) -> [MCTreeNode] {
        //print("getStateUpdates",node.nid)
        //print("depth",depth)
        //print("node.numerator",node.numerator)
        //print("node.denominator",node.denominator)
        
        /*
        if depth == 0 {
            if let parentNode = node.parent {
                //print("nid",node.nid)
                print("parentNode.numerator",parentNode.numerator)
                print("parentNode.denominator",parentNode.denominator)
            }
        }
        */
        
        /*
        var parentCount = 0
        var parentNode: MCTreeNode? = node.parent
        while let pnode = parentNode {
            parentNode = pnode.parent
            parentCount += 1
        }
        print("parents.count",parentCount)
        */
        
        /*
        if depth > 60 {
            return [MLChessTreeNode]()
        }*/
        
        if self.simulationDepth > 0 && depth > self.simulationDepth {
            return [MLChessTreeNode]()
        }
        
        let simNode = node as! MLChessTreeNode
        var possibleStates = [[[MLChessPiece?]]]()
        //var pawnCount = 0
        
        if self.isTestModeEnabled {
            DispatchQueue.main.sync {
                self.game.board = simNode.board
                self.chessBoardView.reloadData()
            }
        }
        
        var indices = stride(from: 0, through: 7, by: +1)
        if simNode.color == MLPieceColor.black {
            indices = stride(from: 7, through: 0, by: -1)
        }
        
        for row in indices {
            for col in indices {
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
        //print("possibleStates.count",possibleStates.count)
        var states: [[[MLChessPiece?]]] = possibleStates
        
        if self.game.moves.count > 0 && depth == 0 && self.evaluationCount == 1 {
            states = [[[MLChessPiece?]]]()
            for istate in possibleStates {
                for jstate in self.game.moves {
                    //if !istate.elementsEqual(jstate)
                    if istate != jstate && !states.contains(istate) {
                        states.append(istate)
                    }
                }
            }
        }
        
        //print("states.count",states.count)
        
        let childNodeColor: MLPieceColor
        
        if simNode.color == MLPieceColor.white {
            childNodeColor = MLPieceColor.black
        } else {
            childNodeColor = MLPieceColor.white
        }
        
        var stateNodes = [MLChessTreeNode]()
        
        for state in states {
            //stateNodes.append(MLChessTreeNode(board: state, color: childNodeColor))
            var isValidState = true
            for row in indices.reversed() {
                for col in indices.reversed() {
                    if let piece = state[row][col] {
                        if piece.color != childNodeColor {
                            continue
                        }
                        let moves: [[[MLChessPiece?]]] = piece.getPossibleMoves(state: state, x: col, y: row)
                        //proof that chessmate is not possible for all moves of this piece
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
        /*
        let netManager = MLChessNetManager()
        
        for node in stateNodes {
            let prediction: [String: Double] = netManager.predict(node.board)
            for key in prediction.keys {
                print(key,prediction[key]!)
            }
        }
        */
        //print("stateNodes.count",stateNodes.count)
        
        return stateNodes
    }
    
    func evaluate(_ currentNode: MCTreeNode, with simNode: MCTreeNode) -> Double {
        //print("evaluate",currentNode.nid,simNode.nid)
        //print("evaluate",currentNode,simNode)
        
        var parentCount = 0
        var parentNode: MCTreeNode? = currentNode.parent
        while let pnode = parentNode {
            //print("pnode.nid",pnode.nid)
            print("parentNode.numerator",pnode.numerator)
            print("parentNode.denominator",pnode.denominator)
            parentNode = pnode.parent
            parentCount += 1
        }
        print("parents.count",parentCount)
        
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
        
        self.evaluationCount += 1
        
        if chessMate {
            return 1
        }
        
        if self.game.active == MLPieceColor.white
            && self.whiteStateEvaluation == MLChessStateEvaluation.Win {
            return 0
        }
        
        if self.game.active == MLPieceColor.black
            && self.blackStateEvaluation == MLChessStateEvaluation.Win {
            return 0
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
    
    func chessBoardView(board: CBChessBoardView, chessPieceForSquare square: CBChessBoardSquare) -> CBChessBoardPiece? {
        //print("chessPieceForSquare", square.row, square.col)
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
    
    //MARK: - CBChessBoardViewDelegate
    
    func chessBoardView(board: CBChessBoardView, didSelectPieceAtPosition square: CBChessBoardSquare) -> Void {
        print(square)
        
        if self.game.active != self.userColor {
            print("not active")
            return
        }
        
        if self.srcPos == nil {
            self.srcPos = square
            self.selectionLabel.text = square.id
            self.desPos = nil
            
            return
        }
        
        self.desPos = square
        self.moveLabel.text = square.id
        
        guard let srcSquare = self.srcPos else {
            return
        }
        
        guard let destSquare = self.desPos else {
            return
        }
        
        self.srcPos = nil
        let node: MLChessTreeNode! = self.mcts.startNode as? MLChessTreeNode
        
        var states: [[[MLChessPiece?]]]?
        
        var i = 0
        
        for row in 0...7 {
            for col in 0...7 {
                if i == srcSquare.index {
                    if let piece = node.board[row][col] {
                        states = piece.getPossibleMoves(state: node.board, x: col, y: row)
                    }
                }
                i += 1
            }
        }
        
        guard let boards = states else {
            return
        }
        
        var nodeColor = MLPieceColor.white
        if self.game.active == MLPieceColor.white {
            nodeColor = MLPieceColor.black
        }
        
        var newNode: MLChessTreeNode?
        
        for pstate in boards {
            var i = 0
            for row in 0...7 {
                for col in 0...7 {
                    if i == destSquare.index {
                        if pstate[row][col] != nil {
                            let treeNode = MLChessTreeNode(board: pstate, color: nodeColor)
                            treeNode.numerator = Double.infinity
                            treeNode.denominator = Double.infinity
                            newNode = treeNode
                        }
                    }
                    i += 1
                }
            }
        }
        
        guard let childNode = newNode else {
            return
        }
        //print("childNode.nid",childNode.nid)
        node.addNode(childNode)
        self.currTime = 1
    }
    
    //MARK: - PSTimerViewController
    
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
            //self.currTime = self.calcTime
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

