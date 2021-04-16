//
//  TheNameGameMenuTest.swift
//  TheNameGameTests
//
//  Created by Iyin Raphael on 4/15/21.
//

import XCTest
@testable import TheNameGame

class TheNameGameMenuTest: XCTestCase {
    var sut: MenuViewModel!
    let gameDefault = UserDefaults.standard
    let gameDefaultKey = "gameMode"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MenuViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testGameChangeToPracticeMode() {
        // given
        let rawValue = gameDefault.integer(forKey: gameDefaultKey)
        let praticeGameMode = GameMode.practiceMode
        
        // when
        sut.changeGameMode(to: praticeGameMode)
        
        // then
        XCTAssertEqual(rawValue, 0, "Game state not in practice mode")
    }
    
    func testGameChangeToTimedMode() {
        // given
        let rawValue = gameDefault.integer(forKey: gameDefaultKey)
        let praticeGameMode = GameMode.timeMode
        
        // when
        sut.changeGameMode(to: praticeGameMode)
        
        // then
        XCTAssertEqual(rawValue, 1, "Game state not in timed mode")
    }

}
