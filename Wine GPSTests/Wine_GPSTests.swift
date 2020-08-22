//
//  Wine_GPSTests.swift
//  Wine GPSTests
//
//  Created by adynak on 8/22/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import XCTest

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
    
    func testCallToInventory() {
      let url = URL(string: "https://www.cellartracker.com/xlquery.asp?User=al00p&Password=Genesis13355Tigard&Format=csv&Table=Inventory&Location=1")
        
      let promise = expectation(description: "Completion handler invoked")
      var statusCode: Int?
      var responseError: Error?
      
      let dataTask = sut.dataTask(with: url!) { data, response, error in
        statusCode = (response as? HTTPURLResponse)?.statusCode
        responseError = error
        promise.fulfill()
      }
      dataTask.resume()
      wait(for: [promise], timeout: 5)
      
      XCTAssertNil(responseError)
      XCTAssertEqual(statusCode, 200)
    }

    func testCallToAvailability() {
      let url = URL(string: "https://www.cellartracker.com/xlquery.asp?User=al00p&Password=Genesis13355Tigard&Format=csv&Table=Availability&Location=1")
        
      let promise = expectation(description: "Completion handler invoked")
      var statusCode: Int?
      var responseError: Error?
      
      let dataTask = sut.dataTask(with: url!) { data, response, error in
        statusCode = (response as? HTTPURLResponse)?.statusCode
        responseError = error
        promise.fulfill()
      }
      dataTask.resume()
      wait(for: [promise], timeout: 5)
      
      XCTAssertNil(responseError)
      XCTAssertEqual(statusCode, 200)
    }

    func testPerformance() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
