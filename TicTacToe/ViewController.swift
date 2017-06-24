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
import RxDataSources

struct TicTacTowSection : SectionModelType {
    
    var items: [String]
    
    init(original: TicTacTowSection, items: [String]) {
        self = original
        self.items = items
    }
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
    
    fileprivate var viewModel: TicTacTowViewModel?
    
    fileprivate lazy var disposeBag: DisposeBag = DisposeBag()
    fileprivate lazy var dataSource = RxCollectionViewSectionedReloadDataSource<TicTacTowSection>()
    
    @IBAction func rstClrButtonPressed(_ sender: Any) {
        clearCells() // <- Does this belong here? Should a View know
                     // about what to do on click of a button i.e. an Action
        winnerTextLabel.text = ""
        viewModel?.reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        winnerTextLabel.text = ""
        
        ticTacTowGrid.rx.setDelegate(self).addDisposableTo(disposeBag)
        ticTacTowGrid.rx.setDataSource(self).addDisposableTo(disposeBag)
        
        ticTacTowGrid.register(TicTacTowCollectionViewCell.self)
        
        // This should be outside ViewController. Currently Dont have
        // Typhoon or any other dependency injection mode.
        viewModel = TicTacTowViewModel(dataModel: Board())
        
        viewModel?.resetButtonText
            .bind(to: rstClrButton.rx.title())
            .addDisposableTo(disposeBag)
        
        viewModel?.resultText
            .bind(to: winnerTextLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel?.declareWinner = { text, indexes in
            self.winnerTextLabel.text = text
            indexes.forEach { self.tttcell(at: $0)?.setWinnerCell() }
        }
        
        dataSource.configureCell = { ds, cv, indexPath, _ in
            return cv.dequeueReusableCell(withReuseIdentifier: TicTacTowCollectionViewCell.reuseIdentifier, for: indexPath) as! TicTacTowCollectionViewCell
        }
        
        ticTacTowGrid.rx.modelSelected(String.self)
            .bind(to: (viewModel?.markTictactoeCell)!)
            .addDisposableTo(disposeBag)
        
        ticTacTowGrid.rx.itemSelected
            .bind(to: self.viewModel?.clickedCell(at: $0))
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




