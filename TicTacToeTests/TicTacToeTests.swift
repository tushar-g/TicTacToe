//
//  TicTacToeTests.swift
//  TicTacToeTests
//
//  Created by Tushar Gupta on 13/06/17.
//  Copyright © 2017 Tushar Gupta. All rights reserved.
//

import XCTest
@testable import TicTacToe

class TicTacToeTests: XCTestCase {
    
    var vm: TicTacTowViewModelProtocol?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vm = TicTacTowViewModel(dataModel : Board())

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_firstMove() {
        let testIndex = IndexPath(row: 0, section: 0)
        vm?.markTictactoeCell = { text, index in
            XCTAssertTrue(text == Player.x.toString && index == testIndex)
        }
        vm?.clickedCell(at: testIndex)
    }
    
    func test_winningMoveRow0() {
        vm?.declareWinner = { text, indexes in
            XCTAssertEqual([IndexPath(row: 0, section: 0),
                            IndexPath(row: 1, section: 0),
                            IndexPath(row: 2, section: 0)], indexes)
            XCTAssertTrue(text != nil)
        }
        
        vm?.clickedCell(at: IndexPath(row: 0, section: 0))
        vm?.clickedCell(at: IndexPath(row: 3, section: 0))
        vm?.clickedCell(at: IndexPath(row: 1, section: 0))
        vm?.clickedCell(at: IndexPath(row: 4, section: 0))
        vm?.clickedCell(at: IndexPath(row: 2, section: 0))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
