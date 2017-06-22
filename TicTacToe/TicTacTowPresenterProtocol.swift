//
//  TicTacToeViewModelProtocol.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 15/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation

protocol TicTacTowPresenterProtocol {
    
    func clickedCell(at indexPath: IndexPath)
    
    func reset()
}
