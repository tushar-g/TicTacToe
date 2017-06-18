//
//  TicTacTowCollectionViewCell.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 11/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import UIKit

class TicTacTowCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textXOLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        textXOLabel.textAlignment = .center
        textXOLabel.textColor = UIColor.black
        textXOLabel.font = UIFont.boldSystemFont(ofSize: 28)
        self.backgroundColor = UIColor.lightGray
    }
    
    func mark(player: String) {
        textXOLabel.text = player
    }
    
    
    func setWinnerCell() {
        textXOLabel.textColor = UIColor.red
    }

    func clear() {
        textXOLabel.text = ""
        textXOLabel.textColor = UIColor.black
    }
}
