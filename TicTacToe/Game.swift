//
//  Game.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 15/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation

enum Game {
    typealias CellIndex = (BoardProtocol.Row, BoardProtocol.Col)
    
    case won(Player, [CellIndex])
    case draw
    case move(Player, CellIndex)
}
