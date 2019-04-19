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
            let fh = try FileHandle(forWritingTo: self.filename)
            fh.seekToEndOfFile()
            fh.write(string.data(using: String.Encoding.utf8)!)
            fh.closeFile()
        } catch {
            return false
        }
        return true
    }
    
    func read() -> String {
        do {
            let str = try String(contentsOf: self.filename, encoding: String.Encoding.utf8)
            return str
        } catch {
            return ""
        }
    }
    
    func clear() -> Bool {
        do {
            try "".write(to: self.filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            return false
        }
        return true
    }

}
