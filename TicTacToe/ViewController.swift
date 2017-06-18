//
//  TicTacToeViewController.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 11/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import UIKit

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
    
    fileprivate var viewModel: TicTacTowViewModel?
    
    @IBAction func rstClrButtonPressed(_ sender: Any) {
        clearCells() // <- Does this belong here? Should a View know
                     // about what to do on click of a button i.e. an Action
        viewModel?.reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        winnerTextLabel.text = ""
        ticTacTowGrid.delegate = self
        ticTacTowGrid.dataSource = self
        ticTacTowGrid.register(TicTacTowCollectionViewCell.self)
        
        // This should be outside ViewController. Currently Dont have
        // Typhoon or any other dependency injection mode.
        viewModel = TicTacTowViewModel(dataModel: Board())
        viewModel?.setActionButtonText = { text in
            self.rstClrButton.setTitle(text, for: UIControlState())
        }
        viewModel?.declareDraw = { text in
            self.winnerTextLabel.text = text
        }
        
        viewModel?.declareWinner = { text, indexes in
            self.winnerTextLabel.text = text
            indexes.forEach { self.tttcell(at: $0)?.setWinnerCell() }
        }
        
        viewModel?.markTictactoeCell = {player, index in
            self.tttcell(at: index)?.mark(player: player)
        }
    }
    
    fileprivate func tttcell(at indexPath: IndexPath) -> TicTacTowCollectionViewCell? {
        return ticTacTowGrid.cellForItem(at: indexPath) as? TicTacTowCollectionViewCell
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
        if let _ = collectionView.cellForItem(at: indexPath) as? TicTacTowCollectionViewCell {
            viewModel?.clickedCell(at: indexPath)
        }
    }
}




