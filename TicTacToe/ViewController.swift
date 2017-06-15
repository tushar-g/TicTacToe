//
//  TicTacToeViewController.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 11/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import UIKit

enum Player : String {
    case X = "X"
    case O = "O"
}

enum GameState {
    case IN_PROGRESS, FINISHED
}

class ViewController: UIViewController {
    
    fileprivate struct Consts {
        static let rows = 3
        static let columns = 3
        static let insetMargin : CGFloat = 60
        static let cellSide : CGFloat = (UIScreen.main.bounds.width - (2 * insetMargin)) / 3
        static let sectionInset = UIEdgeInsets(top: 0, left: insetMargin, bottom: 0, right: insetMargin)
        static let cellSize = CGSize(width: cellSide , height: cellSide)
    }
    
    @IBOutlet weak var ticTacTowGrid: UICollectionView!
    @IBOutlet weak var winnerTextLabel: UILabel!
    @IBOutlet weak var rstClrButton: UIButton!
    
    fileprivate var currentTurn = Player.X
    fileprivate var gameState = GameState.IN_PROGRESS {
        didSet {
            switch gameState {
            case .FINISHED:
                rstClrButton.setTitle("RESTART", for: UIControlState())
            case .IN_PROGRESS:
                rstClrButton.setTitle("CLEAR", for: UIControlState())
            }
        }
    }
    
    @IBAction func rstClrButtonPressed(_ sender: Any) {
        currentTurn = .X
        clearCells()
        winnerTextLabel.text = ""
        gameState = .IN_PROGRESS
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        winnerTextLabel.text = ""
        rstClrButton.setTitle("CLEAR", for: UIControlState())
        ticTacTowGrid.delegate = self
        ticTacTowGrid.dataSource = self
        ticTacTowGrid.register(TicTacTowCollectionViewCell.self)
    }
    
    fileprivate func row(_ indexPath: IndexPath) -> Int {
        return indexPath.row / Consts.rows
    }
    
    fileprivate func column(_ indexPath: IndexPath) -> Int {
        return indexPath.row % Consts.columns
    }
    
    fileprivate func tttcell(r : Int, c: Int) -> TicTacTowCollectionViewCell? {
        return ticTacTowGrid.cellForItem(at: IndexPath(row: r * Consts.rows + c, section: 0)) as?TicTacTowCollectionViewCell
    }
    
    fileprivate func tttcell(at indexPath: IndexPath) -> TicTacTowCollectionViewCell? {
        return ticTacTowGrid.cellForItem(at: indexPath) as? TicTacTowCollectionViewCell
    }
    
    // MARK : Game Logic
    fileprivate func isValidMove(at indexPath: IndexPath) -> Bool {
        return !isCellAlreadyPlayed(at: indexPath)
            && gameState == .IN_PROGRESS
    }
    
    fileprivate func isCellAlreadyPlayed(at indexPath: IndexPath) -> Bool {
        return tttcell(at: indexPath)?.isPlayed ?? false
    }
    
    fileprivate func isWinningMove(by player: Player, currentRow row: Int, currentColumn column: Int) -> (Bool, [IndexPath]?) {
        
        var isWinningRow = true
        [0,1,2].map { tttcell(r: row, c: $0)?.player }
            .forEach { isWinningRow = ($0 == player) && isWinningRow }
        
        var isWinningColumn = true
        [0,1,2].map { tttcell(r: $0, c: column)?.player }
            .forEach { isWinningColumn =  ($0 == player) && isWinningColumn }
        
        var isWinningDialognal1 = row == column
        [0,1,2].map { tttcell(r: $0, c: $0)?.player }
            .forEach { isWinningDialognal1 =  ($0 == player) && isWinningDialognal1 }
        
        var isWinningDialognal2 = row + column == Consts.rows - 1
        [0,1,2].map { tttcell(r: $0, c: 2 - $0)?.player }
            .forEach { isWinningDialognal2 =  ($0 == player) && isWinningDialognal2 }
        
        if isWinningRow {
            return (true, [0,1,2].flatMap { IndexPath(row: Consts.rows * row + $0, section: 0) })
        } else if isWinningColumn {
            return (true, [0,1,2].flatMap { IndexPath(row: Consts.rows * $0 + column, section: 0) })
        } else if isWinningDialognal1 {
            return (true, [0,1,2].flatMap { IndexPath(row: 4 * $0, section: 0) })
        } else if isWinningDialognal2 {
            return (true, [0,1,2].flatMap { IndexPath(row: 2 * $0 + 2, section: 0) })
        }
        
        return (false, nil)
    }
    
    fileprivate func isGameDraw() -> Bool {
        var isGameDraw = true
        Array(0...8).map { tttcell(at: IndexPath(row: $0, section: 0))?.isPlayed }
            .forEach { isGameDraw = ($0 ?? false) && isGameDraw }
        return isGameDraw
    }
    
    fileprivate func declareWinner(indexes: [IndexPath]) {
        indexes.forEach { tttcell(at: $0)?.setWinnerCell(true) }
        winnerTextLabel.text = "Winner is Player \(currentTurn.rawValue)"
    }
    
    fileprivate func declareDraw() {
        winnerTextLabel.text = "Draw"
    }
    
    fileprivate func flipTurn() {
        currentTurn = currentTurn == .X ? .O : .X
    }
    
    fileprivate func markCell(at indexPath: IndexPath) {
        tttcell(at: indexPath)?.player = currentTurn
    }
    
    fileprivate func clearCells() {
        ticTacTowGrid.indexPathsForVisibleItems.forEach{ tttcell(at: $0)?.clear() }
    }
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Consts.rows * Consts.columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Consts.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Consts.sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicTacTowCollectionViewCell.reuseIdentifier, for: indexPath) as? TicTacTowCollectionViewCell {
            cell.assign(row: row(indexPath), column: column(indexPath))
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currentCell = collectionView.cellForItem(at: indexPath) as? TicTacTowCollectionViewCell {
            if isValidMove(at: indexPath) {
                markCell(at: indexPath)
                let (isWinning, indexes) = isWinningMove(by: currentTurn, currentRow: currentCell.row, currentColumn: currentCell.column)
                if let indexes = indexes, isWinning == true {
                    gameState = .FINISHED
                    declareWinner(indexes: indexes)
                } else if isGameDraw() {
                    gameState = .FINISHED
                    declareDraw()
                } else {
                    flipTurn()
                }
            }
        }
    }
}




