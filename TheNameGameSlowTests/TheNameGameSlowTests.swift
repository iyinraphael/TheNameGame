//
//  TheNameGameSlowTests.swift
//  TheNameGameSlowTests
//
//  Created by Iyin Raphael on 4/15/21.
//

import XCTest
@testable import TheNameGame

class TheNameGameSlowTests: XCTestCase {
    var sut: URLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testApiCallCompletes() throws {
        // given
        let urlString = "https://willowtreeapps.com/api/v1.0/profiles"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sut.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200, "Network call successFull")
    }

}
