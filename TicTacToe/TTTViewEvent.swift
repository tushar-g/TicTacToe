//
//  TTTViewEvent.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 01/08/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation

enum TTTViewEvent {
    case moveMade(String, IndexPath)
    case gameDraw(String)
    case gameWon(String, [IndexPath])
    case gameReset
}
