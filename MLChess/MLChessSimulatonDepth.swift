//
//  MLChessSimulatonDepth.swift
//  MLChess
//
//  Created by Philipp Schunker on 30.05.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import Foundation

enum MLChessSimulationDepth: Int, Codable {
    case Terminal = 0
    case Short = 20
    case Medium = 40
    case Long = 60
}
