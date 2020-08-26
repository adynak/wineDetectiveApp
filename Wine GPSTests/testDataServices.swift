//
//  testDataServices.swift
//  Wine GPSTests
//
//  Created by adynak on 8/22/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import XCTest
@testable import WineGPS

class testDataServices: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testgetDataUrlInventory(){
        let dataUrl = DataServices.getDataUrl(user: "user",pword: "pword", table: "Inventory")
        let params = dataUrl.split(separator: "?", maxSplits: 1)
        let param = "\(params[1])"
        let result = "User=user&Password=pword&Format=csv&Table=Inventory&Location=1"
        XCTAssertEqual(param, result, "expected URL not returned")
    }
    
    func testgetDataUrlAvailability(){
        let dataUrl = DataServices.getDataUrl(user: "user",pword: "pword", table: "Availability")
        let params = dataUrl.split(separator: "?", maxSplits: 1)
        let param = "\(params[1])"
        let result = "User=user&Password=pword&Format=csv&Table=Availability&Location=1"
        XCTAssertEqual(param, result, "expected URL not returned")
    }

    func testCallToInventory() {

        let dataUrl = DataServices.getDataUrl(user: "user",pword: "pword", table: "Inventory")
        
        let url = URL(string: dataUrl)

        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
      
        let dataTask = URLSession.shared.dataTask(with: url!) { data, response, error in
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
        let dataUrl = DataServices.getDataUrl(user: "user",pword: "pword", table: "Availability")
        
        let url = URL(string: dataUrl)

        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
      
        let dataTask = URLSession.shared.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)

        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

}
