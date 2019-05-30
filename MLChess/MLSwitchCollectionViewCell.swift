//
//  MLSwitchCollectionViewCell.swift
//  MLChess
//
//  Created by Philipp Schunker on 21.05.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLSwitchCollectionViewCell: UICollectionViewCell {
    
    var uiswitch: UISwitch!
    var label: UILabel!
    var insets: UIEdgeInsets!
    var separator: CALayer?
    var separatorActive: Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.uiswitch = UISwitch()
        self.label = UILabel()
        self.separatorActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupSubviews() -> Void {
        //
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(self.uiswitch)
        self.contentView.addSubview(self.label)
        
        let bounds: CGRect = self.contentView.bounds
        self.uiswitch.frame = bounds.inset(by: UIEdgeInsets(top: 6, left: self.contentView.frame.width - self.uiswitch.frame.width-10, bottom: 4, right: 0))
        self.label.frame = bounds.inset(by: UIEdgeInsets(top: 6, left: 10, bottom: 4, right: 10))
        
        if self.separatorActive {
            let height: CGFloat = 0.5
            let left: CGFloat = self.insets.left
            
            let separator = CALayer()
            separator.frame = CGRect(x: left, y: bounds.size.height-height, width: bounds.size.width-left, height: height)
            separator.backgroundColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 1).cgColor
            self.contentView.layer.addSublayer(separator)
            self.separator = separator
        }
    }
    
}
