
//
//  TicTacToeViewModel.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 15/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation

class TicTacTowViewModel : TicTacTowViewModelProtocol {
    
    var markTictactoeCell: ((String, IndexPath) -> ())?
    
    var declareDraw: ((String) -> ())?
    
    var declareWinner: ((String, [IndexPath]) -> ())?
    
    var setActionButtonText: ((String) -> ())? {
        didSet {
            setActionButtonText?("Clear")
        }
    }
    
    private var dataModel : BoardProtocol? {
        didSet {
            dataModel?.moveCompleter = { game in
                switch game {
                case .move(let player, let index):
                    self.markTictactoeCell?(player.toString,
                                            IndexPath(index.0, index.1))
                    
                case .draw:
                    self.declareDraw?("Draw")
                    self.setActionButtonText?("Reset")
                    
                case .won(let player, let indices):
                    let indexPaths: [IndexPath] = indices.flatMap {
                        IndexPath($0.0, $0.1)
                    }
                    self.declareWinner?("Winner is \(player.toString)", indexPaths)
                    self.setActionButtonText?("Reset")
                    
                }
            }
        }
    }
    
    init(dataModel: BoardProtocol) {
        self.dataModel = dataModel
    }

    func reset() {
        dataModel?.reset()
        setActionButtonText?("Clear")
    }
    
    func clickedCell(at indexPath: IndexPath) {
        dataModel?.mark(row: indexPath.row / 3, col: indexPath.row % 3)
    }
}

extension IndexPath {
    init(_ row: Int, _ col: Int) {
        self.init(row: row * 3 + col, section: 0)
    }
}
