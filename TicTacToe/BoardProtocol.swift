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
    
    var moveCompleter: ((Game) -> Void)? {get set}
    
    func mark(row: Row, col: Col)
    
    func reset()
}
