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
    
    func getBestPredictions(node: MLChessTreeNode, stateNodes: [MLChessTreeNode]) -> [MLChessTreeNode] {
        var predKey = "white"
        if node.color == MLPieceColor.black {
            predKey = "black"
        }
        
        //print(predKey)
        
        //var cnt = 0
        var median = Double(0)
        var array: [Double] = [Double]()
        
        for node in stateNodes {
            let prediction: [String: Double] = self.predict(node.board)
            /*
            for key in prediction.keys {
                //print(key,prediction[key]!)
                if prediction[predKey]! > 0.5 {
                    cnt += 1
                }
                //prediction[predKey]!
            }*/
            //print(prediction[predKey]!)
            array.append(prediction[predKey]!)
        }
        
        //print("value.count", array.count)
        
        median = array.median(array: array)
        //print("median prediction", median)
        
        var bestStateNodes = [MLChessTreeNode]()
        var i = 0
        
        for value in array {
            if value >= median {
                bestStateNodes.append(stateNodes[i])
            }
            i += 1
        }
        
        return bestStateNodes
    }
}
