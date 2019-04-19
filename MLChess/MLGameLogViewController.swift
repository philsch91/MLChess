//
//  SecondViewController.swift
//  MLChess
//
//  Created by Philipp Schunker on 27.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLGameLogViewController: UIViewController {
    
    var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Logs"
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //var tst: String = "Hello World"
        /*
        for _ in 0...10000 {
            tst += "Hello World"
        }*/
        let logManager = MLGameLogManager()
        let log = logManager.read()
        self.textView.text = log
    }
    
    func setupUI() -> Void {
        self.view.backgroundColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(self.clearLog))
        
        self.textView = UITextView()
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(textView)
        
        let views: [UIView] = [self.textView]
        self.view.addVisualConstraints(visualFormat: "H:|[v1]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: views)
        self.view.addVisualConstraints(visualFormat: "V:|[v1]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
    }
    
    @objc func clearLog() -> Void {
        let logManager = MLGameLogManager()
        _ = logManager.clear()
        let log = logManager.read()
        self.textView.text = log
    }


}

