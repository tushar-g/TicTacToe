
//
//  TicTacToeViewModel.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 15/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation

class TicTacTowPresenter : TicTacTowPresenterProtocol {
    
    private var dataModel : BoardProtocol?
    
    private weak var tttView: TicTacToeViewProtocol?
    
    init(_ view: TicTacToeViewProtocol, _ dataModel: BoardProtocol) {
        self.dataModel = dataModel
        self.tttView = view
        
        tttView?.setActionButtonText("Clear")
        
        self.dataModel?.moveCompleter = { game in
                switch game {
                case .move(let player, let index):
                    tttView?.markTictactoeCell(player.toString,
                                            IndexPath(index.0, index.1))
                    
                case .draw:
                    tttView?.declareDraw("Draw")
                    tttView?.setActionButtonText("Reset")
                    
                case .won(let player, let indices):
                    let indexPaths: [IndexPath] = indices.flatMap {
                        IndexPath($0.0, $0.1)
                    }
                    tttView?.declareWinner("Winner is \(player.toString)", indexPaths)
                    tttView?.setActionButtonText("Reset")
                    
                }
        }
    }

    func reset() {
        dataModel.reset()
        setActionButtonText?("Clear")
    }
    
    func clickedCell(at indexPath: IndexPath) {
        dataModel.mark(row: indexPath.row / 3, col: indexPath.row % 3)
    }
}

private extension IndexPath {
    init(_ row: Int, _ col: Int) {
        self.init(row: row * 3 + col, section: 0)
    }
}
