//
//  MLSegmentedCollectionViewCell.swift
//  MLChess
//
//  Created by Philipp Schunker on 18.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLSegmentedCollectionViewCell: UICollectionViewCell {
    
    var segmentedControl: UISegmentedControl!
    var insets: UIEdgeInsets!
    var separator: CALayer?
    var separatorActive: Bool!
    var items: [Any]! {
        didSet (oldValue){
            self.segmentedControl = UISegmentedControl(items: self.items)
        }
    }
    var selectedIndex: Int! {
        didSet (oldValue) {
            self.segmentedControl.selectedSegmentIndex = self.selectedIndex
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.items = [Any]()
        self.segmentedControl = UISegmentedControl(items: self.items)
        self.selectedIndex = 0
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
        self.contentView.addSubview(self.segmentedControl)
        
        let bounds: CGRect = self.contentView.bounds
        self.segmentedControl.frame = bounds.inset(by: UIEdgeInsets(top: 14, left: 10, bottom: 14, right: 10))
        
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
