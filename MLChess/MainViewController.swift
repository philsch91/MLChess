//
//  FirstViewController.swift
//  MLChess
//
//  Created by Philipp Schunker on 27.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var board: MLChessBoardView?
    var game: MLChessGame?
    var controller: MLChessBoardViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title="MLChess"
        //self.edgesForExtendedLayout = []
        self.setupUI()
        //self.setupNewGame()
    }
    
    func setupUI() -> Void {
        NSLog("setupUI")
        var frame: CGRect = self.view.frame //as CGRect
        frame.size.height=frame.size.width
        //frame.size.width-=20.0
        frame.origin.y+=CGFloat(100)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Game", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.setupNewGame))
        
        let board = MLChessBoardView(frame: frame)
        self.board = board
        /*
        if let navBar = self.navigationController {
            // pin containerView to *bottom* of navBar view
            //board.topAnchor.constraint(equalTo: navBar.view.bottomAnchor).isActive = true
        } else {
            // pin containerView to *top* of view
            //board.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }*/
        
        //board.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        self.view.addSubview(board)
    }
    
    @objc func setupNewGame() -> Void {
        print("setupNewGame")
        if case let controller? = self.controller {
            controller.reset()
        }
        if case let board? = self.board {
            let controller: MLChessBoardViewController = MLChessBoardViewController(board)
            self.controller = controller
        }
        let game = MLChessGame()
        self.game = game
        self.controller?.updateView(state: game.board)
    }


}

