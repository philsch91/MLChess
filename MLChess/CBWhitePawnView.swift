//
//  CBWhitePawnView.swift
//  MLChess
//
//  Created by Philipp Schunker on 05.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class CBWhitePawnView: CBChessPieceView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.font = UIFont(name: "Helvetica", size: 28)
        self.font = UIFont.systemFont(ofSize: 32)
        self.text="\u{2659}"
        //self.text = String(format: "%C", 0x2659)
        //self.text="♙"
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
