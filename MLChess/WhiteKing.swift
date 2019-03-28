//
//  WhiteKing.swift
//  MLChess
//
//  Created by Philipp Schunker on 28.03.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class WhiteKing: UILabel {
    
    override init(frame: CGRect) {
        //self.size=Float(frame.size.width-20.0)
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.text="♔"
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
