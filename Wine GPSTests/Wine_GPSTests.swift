//
//  Wine_GPSTests.swift
//  Wine GPSTests
//
//  Created by adynak on 8/22/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import XCTest
@testable import Wine_GPS

class Wine_GPSTests: XCTestCase {

    var sut: URLSession!

    override func setUp() {
      super.setUp()
      sut = URLSession(configuration: .default)
    }
    
    override func tearDown() {
      sut = nil
      super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFunction() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformance() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
