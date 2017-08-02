//
//  TicTacToeViewController.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 11/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    fileprivate lazy var disposeBag: DisposeBag = DisposeBag()
    
    @IBAction func rstClrButtonPressed(_ sender: Any) {
        viewModel?.reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This should be outside ViewController. Currently Dont have
        // Typhoon or any other dependency injection mode.
        viewModel = TicTacTowViewModel(dataModel: Board())
        
        winnerTextLabel.text = ""
        
        ticTacTowGrid.register(TicTacTowCollectionViewCell.self)
        ticTacTowGrid.delegate = self
        ticTacTowGrid.dataSource = self
        
        if let flow = ticTacTowGrid.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.minimumLineSpacing = 0
            flow.minimumInteritemSpacing = 0
            flow.sectionInset = Consts.sectionInset
            flow.itemSize = Consts.cellSize
        }
        
        viewModel?.viewState.subscribe(onNext: { state in
            switch state {
            case .gameReset:
                self.winnerTextLabel.text = ""
                self.clearCells()
                
            case .moveMade(let celltext, let indexPath):
                self.tttcell(at: indexPath)?.mark(player: celltext)
                
            case .gameWon(let text, let indexes):
                self.winnerTextLabel.text = text
                indexes.forEach { self.tttcell(at: $0)?.setWinnerCell() }
                
            case .gameDraw(let text):
                self.winnerTextLabel.text = text
                
            }
        }).addDisposableTo(disposeBag)

        viewModel?.resetText
            .bind(to: rstClrButton.rx.title())
            .addDisposableTo(disposeBag)
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicTacTowCollectionViewCell.reuseIdentifier, for: indexPath) as? TicTacTowCollectionViewCell {
            return cell
        }
        
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.cellForItem(at: indexPath) as? TicTacTowCollectionViewCell {
            viewModel?.clickedCell(at: indexPath)
        }
    }
}




