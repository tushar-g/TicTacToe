//
//  Game.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 15/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation

enum Game {
    case won(Player, [(Int, Int)])
    case draw
    case move(Player)
    case invalid
}
