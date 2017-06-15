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
    
    var player: Player? {
        didSet {
            textXOLabel.text = player?.rawValue
        }
    }
    
    var isPlayed : Bool {
        return player != nil
    }
    
    var row: Int = 0
    var column: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        textXOLabel.textAlignment = .center
        textXOLabel.textColor = UIColor.black
        textXOLabel.font = UIFont.boldSystemFont(ofSize: 28)
        self.backgroundColor = UIColor.lightGray
    }
    
    
    
    func setWinnerCell(_ bool : Bool) {
        if bool {
            textXOLabel.textColor = UIColor.red
        }
    }
    
    func assign(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    
    func clear() {
        textXOLabel.text = ""
        textXOLabel.textColor = UIColor.black
        player = nil
    }
}
