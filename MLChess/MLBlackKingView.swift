//
//  MLBlackKing.swift
//  MLChess
//
//  Created by Philipp Schunker on 02.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLBlackKingView: MLChessPieceView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.text="♚"
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
