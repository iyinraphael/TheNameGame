//
//  TheNameGameTests.swift
//  TheNameGameTests
//
//  Created by Iyin Raphael on 4/2/21.
//

import XCTest
@testable import TheNameGame

class TheNameGameTests: XCTestCase {
    var sut: GameViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = GameViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    
    func testGameViewMode() {
        guard let allProfiles = GameViewModel().filteredProfiles else { return }
        
        waitForExpectations(timeout: 8, handler: nil)
        
        XCTAssertTrue(!allProfiles.isEmpty)
    }
    

}
