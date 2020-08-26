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
    
    var underTest: BinTableViewCell!
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSetupLabelText(){
        
        let singularText = NSLocalizedString("singularBottle", comment: "singular bottle")
        let pluralText = NSLocalizedString("pluralBottle", comment: "plural bottles")

//        let singular = underTest.setLabelText(count:(Int("1"))!)
//        XCTAssertEqual(singular, singularText, "expected singular not returned")
        
//        let plural = underTest!.setLabelText(count:(Int("2"))!)
//        XCTAssertEqual(plural, pluralText, "expected plural not returned")
        
    }

    

}
