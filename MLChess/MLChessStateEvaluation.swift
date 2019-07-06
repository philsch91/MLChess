//
//  MLChessStateEvaluation.swift
//  MLChess
//
//  Created by Philipp Schunker on 05.07.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import Foundation

enum MLChessStateEvaluation: Int, Codable {
    case Win = 0
    case PawnUnits = 1
    case NeuralNet = 2
}
