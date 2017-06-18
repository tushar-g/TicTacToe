//
//  TicTacToeViewModelProtocol.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 15/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation

protocol TicTacTowViewModelProtocol {
    
    var markTictactoeCell: ((String, IndexPath) -> ())? { get set }
    
    var declareDraw: ((String) -> ())? { get set }
    
    var declareWinner: ((String, [IndexPath]) -> ())? { get set }
    
    var setActionButtonText: ((String) -> ())? { get set }
    
    func clickedCell(at indexPath: IndexPath)
    
    func reset()
}
