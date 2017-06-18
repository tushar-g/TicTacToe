
//
//  TicTacToeViewModel.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 15/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation

class TicTacTowViewModel : TicTacTowViewModelProtocol {
    
    private var dataModel : BoardProtocol
    
    init(dataModel: BoardProtocol) {
        self.dataModel = dataModel
    }
    
    var markTictactoeCell : ((String, IndexPath) -> ())?
    
    var declareDraw: ((String) -> ())?
    
    var declareWinner: ((String, [IndexPath]) -> ())?
    
    var setActionButtonText: ((String) -> ())? {
        didSet {
            setActionButtonText?("Clear")
        }
    }
    
    func reset() {
        dataModel.reset()
        setActionButtonText?("Clear")
    }
    
    func clickedCell(at indexPath: IndexPath) {
        let game = dataModel.mark(row: indexPath.row / 3, col: indexPath.row % 3)
        
        switch game {
        case .move(let player):
            markTictactoeCell?(player.toString, indexPath)
            
        case .draw:
            declareDraw?("Draw")
            setActionButtonText?("Reset")
            
        case .won(let player, let indices):
            let indexPaths: [IndexPath] = indices.flatMap { IndexPath(row: $0.0 * 3 + $0.1, section: 0) }
            declareWinner?("Winner is \(player.toString)", indexPaths)
            setActionButtonText?("Reset")
            
        default: ()
        }
    }
}
