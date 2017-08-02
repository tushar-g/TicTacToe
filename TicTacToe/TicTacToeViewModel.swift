
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
    
    fileprivate var dataModel : BoardProtocol?
    
    fileprivate var resetStream = Variable<Void>()
    var viewState: Observable<TTTViewEvent>? {
        guard let gameMove = dataModel?.gameMove else { return nil }
        
        return Observable.merge([resetStream.asObservable().map { return TTTViewEvent.gameReset } ,
                                 gameMove.do(onNext: {
                                    switch $0 {
                                    case .won(_, _), .draw:
                                        self._resetButtonText.value = "Reset"
                                    default: ()
                                    }
                                 }).map { game in
                                    switch game {
                                    case .draw:
                                        return TTTViewEvent.gameDraw("Draw")
                                        
                                    case .move(let player, let index):
                                        return TTTViewEvent.moveMade(player.toString, IndexPath(index.0, index.1))
                                        
                                    case .won(let player, let indexes):
                                        return TTTViewEvent.gameWon(player.toString, indexes.flatMap { IndexPath($0.0, $0.1) } )
                                    }
                                    }.startWith(TTTViewEvent.gameReset)])
    }
    
    fileprivate var _resetButtonText = Variable<String>("Clear")
    var resetText: Observable<String> {
        return _resetButtonText.asObservable()
    }
    
    init(dataModel: BoardProtocol) {
        self.dataModel = dataModel
    }

    func reset() {
        dataModel?.reset()
        _resetButtonText.value = "Clear"
        resetStream.value = ()
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
