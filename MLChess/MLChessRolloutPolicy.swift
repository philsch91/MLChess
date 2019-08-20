//
//  MLChessRolloutPolicy.swift
//  MLChess
//
//  Created by Philipp Schunker on 20.08.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import Foundation

enum MLChessRolloutPolicy: Int, Codable {
    case Random = 0     //Light
    case NeuralNet = 1  //Heavy
}
