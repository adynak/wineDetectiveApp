//
//  testTableBinCell.swift
//  WineGPSTests
//
//  Created by adynak on 8/25/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import XCTest
@testable import WineGPS


class testTableBinCell: XCTestCase {
    
    var underTest = BinTableViewCell()
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSetupLabelText(){
        
        let singularText = NSLocalizedString("singularBottle", comment: "singular for the word bottle")
        let pluralText = NSLocalizedString("pluralBottle", comment: "plural of the word bottle")
        var count: Int
        var result: String
        var bottleString: String
        
        count = 0
        result = underTest.setLabelText(count:count)
        bottleString = "\(count)" + pluralText
        XCTAssertEqual(bottleString, result, "expected plural not returned")
        
        count = 1
        result = underTest.setLabelText(count:count)
        bottleString = "\(count)" + singularText
        XCTAssertEqual(bottleString, result, "expected singular not returned")
        
        count = 2
        result = underTest.setLabelText(count:count)
        bottleString = "\(count)" + pluralText
        XCTAssertEqual(bottleString, result, "expected plural not returned")
        
    }

    

}
