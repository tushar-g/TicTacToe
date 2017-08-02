
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
    
    fileprivate lazy var disposeBag = DisposeBag()
    
    fileprivate var dataModel : BoardProtocol?
    
    fileprivate var _viewState = Variable<TTTViewEvent>(.gameReset)
    var viewState: Observable<TTTViewEvent> {
        return _viewState.asObservable()
    }
    
    fileprivate var _resetButtonText = Variable<String>("Clear")
    var resetText: Observable<String> {
        return _resetButtonText.asObservable()
    }
    
    init(dataModel: BoardProtocol) {
        self.dataModel = dataModel
        self.dataModel?.gameMove.subscribe {
            switch $0 {
            case .next(let game):
                self.sendViewEvent(game)
                
            case .error(_):
                break
                
            case .completed:
                break
            }
            }.addDisposableTo(disposeBag)
    }

    fileprivate func sendViewEvent(_ game: Game) {
        switch game {
        case .draw:
            _viewState.value = TTTViewEvent.gameDraw("Draw")
            _resetButtonText.value = "Reset"
            
        case .move(let player, let index):
            _viewState.value = TTTViewEvent.moveMade(player.toString, IndexPath(index.0, index.1))
            
        case .won(let player, let indexes):
            _viewState.value = TTTViewEvent.gameWon(player.toString, indexes.flatMap { IndexPath($0.0, $0.1) } )
            _resetButtonText.value = "Reset"
        }
    }

    func reset() {
        dataModel?.reset()
        _resetButtonText.value = "Clear"
        _viewState.value = .gameReset
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
