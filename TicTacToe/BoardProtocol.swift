//
//  BoardProtocol.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 15/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation

protocol BoardProtocol {
    
    typealias Row = Int
    typealias Col = Int
    
    func mark(row: Row, col: Col) -> Game
    
    func reset()
}
