//
//  MLChessNetManager.swift
//  MLChess
//
//  Created by Philipp Schunker on 25.07.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import Foundation
import CoreML

class MLChessNetManager {
    
    func predict(_ state: [[MLChessPiece?]]) -> [String: Double] {
        var array = Array<Double>()
        
        for row in 0...7 {
            for col in 0...7 {
                var dbl = 0.5   //Double
                
                if let piece = state[row][col] {
                    dbl = (Double(piece.id)-(-10))/(10-(-10))
                }
                
                array.append(dbl)
            }
        }
        
        do {
            let multiArrayInput = try? MLMultiArray(shape:[64], dataType:MLMultiArrayDataType.double)
            var i = 0
            for x in array {
                multiArrayInput![i] = NSNumber(floatLiteral: x)
                i += 1
            }
            
            let input = ChessNetInput(game_state: multiArrayInput!)
            
            let net = ChessNet()
            let output = try net.prediction(input: input)
            
            return output.output
        } catch let error {
            print(error)
            return [String: Double]()
        }
    }
}
