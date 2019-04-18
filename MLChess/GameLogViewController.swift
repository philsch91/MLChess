//
//  SecondViewController.swift
//  MLChess
//
//  Created by Philipp Schunker on 27.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class GameLogViewController: UIViewController {
    
    var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Logs"
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var tst: String = "Hello World"
        for _ in 0...10000 {
            tst += "Hello World"
        }
        self.textView.text = tst
    }
    
    func setupUI() -> Void {
        self.view.backgroundColor = UIColor.black
        //return
        self.textView = UITextView()
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(textView)
        
        let views: [UIView] = [self.textView]
        self.view.addVisualConstraints(visualFormat: "H:|[v1]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: views)
        self.view.addVisualConstraints(visualFormat: "V:|[v1]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
    }


}

