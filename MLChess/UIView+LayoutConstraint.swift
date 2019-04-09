//
//  UIView+LayoutConstraint.swift
//  MLChess
//
//  Created by Philipp Schunker on 09.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addVisualConstraints(visualFormat: String, options: NSLayoutConstraint.FormatOptions, metrics: [String: Any]?, views: [UIView]) -> Void {
        
        var newViews: [String: UIView] = ["v0":self]
        var i: Int = 1
        for view in views {
            let key: String = "v" + String(i)
            newViews.updateValue(view, forKey: key)
            i += 1
        }
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: options, metrics: metrics, views: newViews))
    }
}
