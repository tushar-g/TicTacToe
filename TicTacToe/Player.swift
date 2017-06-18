//
//  Player.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 15/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation

enum Player {
    case x, o, none
    
    var toString: String {
        switch self {
        case .x:
            return "X"
            
        case .o:
            return "O"
            
        case .none:
            return ""
        }
    }
}
