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
        self.filename = paths[0].appendingPathComponent("MLChessGames.txt")
    }
    
    init(url: URL) {
        self.filename = url
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
    
    func save(game: MLChessGame) -> Void {
        var games: [MLChessGame]!
        
        let str = self.read()
        
        if str == "" {
            print("empty")
            games = [MLChessGame]()
        } else {
            let decoder = JSONDecoder()
            let json = str.data(using: String.Encoding.utf8)!
            games = try? decoder.decode([MLChessGame].self, from: json)
        }
        
        games.append(game)
        
        let encoder = JSONEncoder()
        //encoder.outputFormatting = JSONEncoder.OutputFormatting.prettyPrinted
        //let jsonData = try? encoder.encode(self.game)
        let jsonData = try? encoder.encode(games)
        
        if let json = String(data: jsonData!, encoding: String.Encoding.utf8){
            _ = self.clear()
            _ = self.write(string: json)
        }
    }

}
