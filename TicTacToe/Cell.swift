//
//  Cell.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 15/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation

class Cell {
    var player: Player = .none
    
    func clear() {
        self.player = .none
    }
}
