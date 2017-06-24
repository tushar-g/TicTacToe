
//
//  TicTacToeViewModel.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 15/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation
import RxSwift

class TicTacTowViewModel : TicTacTowViewModelProtocol {
    
    var markTictactoeCell = Variable<String>("")
    
    var declareDraw: ((String) -> ())?
    
    var declareWinner: ((String, [IndexPath]) -> ())?
    
    var setActionButtonText: ((String) -> ())? {
        didSet {
            setActionButtonText?("Clear")
        }
    }
    
    fileprivate var _resetButtonText = Variable<String>("Clear")
    var resetButtonText: Observable<String> {
        return _resetButtonText.asObservable()
    }
    
    fileprivate var _winnerLabelText = Variable<String>("")
    var resultText : Observable<String> {
        return _winnerLabelText.asObservable()
    }

    private var dataModel : BoardProtocol? {
        didSet {
            dataModel?.moveCompleter = { game in
                switch game {
                case .move(let player, let _):
                    self.markTictactoeCell.value = player.toString
                    
//                    self.markTictactoeCell(player.toString,
//                                            IndexPath(index.0, index.1))
                    
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

private extension IndexPath {
    init(_ row: Int, _ col: Int) {
        self.init(row: row * 3 + col, section: 0)
    }
}
