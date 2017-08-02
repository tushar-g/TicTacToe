//
//  BoardProtocol.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 15/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation
import RxSwift

protocol BoardProtocol {
    
    typealias Row = Int
    typealias Col = Int
    
    var gameMove: Observable<Game> { get }
    
    func mark(row: Row, col: Col)
    
    func reset()
}
