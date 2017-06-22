//
//  View.swift
//  TicTacToe
//
//  Created by Tushar Gupta on 22/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import Foundation

protocol TicTacToeViewProtocol {
    func markTictactoeCell(_ text: String, _ index: IndexPath)
    
    func declareDraw(_ text: String)
    
    func declareWinner(_ text: String, _ indexes: [IndexPath])
    
    func setActionButtonText(_ text: String)
}
