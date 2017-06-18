//
//  Board.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 15/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation

class Board : BoardProtocol {
    
    fileprivate enum GameState {
        case in_progress, finished
    }
    
    fileprivate var currentTurn: Player = .x
    fileprivate var gameState: GameState = .in_progress
    fileprivate let cells: [[Cell]] = Array(repeating: Array(repeating: Cell(), count: 3), count: 3)
    
    init() {
        reset()
    }
    
    func reset() {
        cells.forEach { $0.forEach { $0.clear() } }
        currentTurn = .x
    }
    
    func mark(row: Row, col: Col) -> Game {
        if isValidMove(row, col) {
            cells[row][col].player = currentTurn
            
            let game = isWinningMove(by: currentTurn, atRow: row, atCol: col)
            if let indices = game.1, game.0 == true {
                return Game.won(currentTurn, indices)
            }
            
            if isDraw() {
                return Game.draw
            }
            
            let lastMoveBy = currentTurn
            flipTurn()
            return Game.move(lastMoveBy)
        }
        return Game.invalid
    }
    
    private func isValidMove(_ row: Row, _ col: Col) -> Bool {
        return cells[row][col].player != .none && gameState == .in_progress
    }
    
    private func isWinningMove(by player: Player, atRow row: Row, atCol col: Col) -> (Bool, [(Row, Col)]?) {
        
        let tttIndices = [0,1,2]
        
        let isWinningRow = tttIndices.map {cells[row][$0].player == player}.reduce(true, {$0 && $1})
        if isWinningRow {
            return (true, tttIndices.flatMap {(row, $0)})
        }
        
        let isWinningCol = tttIndices.map {cells[$0][col].player == player}.reduce(true, {$0 && $1})
        if isWinningCol {
            return (true, tttIndices.flatMap {($0, col)})
        }
        
        let isWinningDiag1 = tttIndices.map {cells[$0][$0].player == player}.reduce(row == col, {$0 && $1})
        if isWinningDiag1 {
            return (true, tttIndices.flatMap {($0, $0)})
        }
        
        let isWinningDiag2 = tttIndices.map {cells[$0][2 - $0].player == player}.reduce(row + col == 2, {$0 && $1})
        if isWinningDiag2 {
            return (true, tttIndices.flatMap {($0, 2 - $0)})
        }
        
        return (false, nil)
    }
    
    private func isDraw() -> Bool {
        return cells.map {$0.map {$0.player != .none}.reduce(true) {$0 && $1}}.reduce(true) {$0 && $1}
    }
    
    private func flipTurn() {
        currentTurn = currentTurn == .x ? .o : .x
    }
}
