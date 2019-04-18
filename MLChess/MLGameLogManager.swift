//
//  MLGameLogManager.swift
//  MLChess
//
//  Created by Philipp Schunker on 18.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit

class MLGameLogManager: NSObject {
    
    let filename: URL!
    
    override init() {
        let paths = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        self.filename = paths[0].appendingPathComponent("game.log")
    }
    
    func write(string: String) -> Bool {
        do {
            try string.write(to: self.filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            return false
        }
        return true
    }

}
