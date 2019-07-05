//
//  MLChessPieceView.swift
//  MLChess
//
//  Created by Philipp Schunker on 05.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class CBChessPieceView: UILabel {
    
    override init(frame: CGRect) {
        //self.size=Float(frame.size.width-20.0)
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        //self.font = UIFont.systemFont(ofSize: 38)
        self.font = UIFont.boldSystemFont(ofSize: 42)
        self.textAlignment = NSTextAlignment.center
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
