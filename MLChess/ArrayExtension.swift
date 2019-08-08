//
//  ArrayExtension.swift
//  MLChess
//
//  Created by Philipp Schunker on 08.08.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import Foundation

extension Array where Element == Double {
    func median(array: [Double]) -> Double {
        let sorted = array.sorted()
        if sorted.count % 2 == 0 {
            return Double((sorted[(sorted.count / 2)] + sorted[(sorted.count / 2) - 1])) / 2
        } else {
            return Double(sorted[(sorted.count - 1) / 2])
        }
    }
}
