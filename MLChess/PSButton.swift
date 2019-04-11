//
//  PSButton.swift
//  MLChess
//
//  Created by Philipp Schunker on 11.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class PSButton: UIButton {
    
    var color: UIColor!
    var highlightedColor: UIColor!
    
    override var isHighlighted: Bool {
        didSet(oldValue) {
            //print("isHighLighted",self.isHighlighted)
            //print("isSelected",self.isSelected)
            
            if(oldValue) {
                print("true")
                self.backgroundColor = self.color
            } else {
                print("false")
                self.backgroundColor = self.highlightedColor
            }
            
            /*
            if self.isHighlighted {
                self.backgroundColor = self.color
            } else {
                self.backgroundColor = self.highlightedColor
            }*/
        }
    }
    
    init(color: UIColor, highlightedColor: UIColor) {
        super.init(frame: CGRect.zero)
        self.color = color
        self.highlightedColor = color
        self.layer.backgroundColor = self.color.cgColor
        self.layer.cornerRadius = 5.0
    }
    
    init(frame: CGRect, color: UIColor, highlightedColor: UIColor) {
        super.init(frame: frame)
        self.color = color
        self.highlightedColor = highlightedColor
        self.layer.backgroundColor = self.color.cgColor
        self.layer.cornerRadius = 5.0
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
