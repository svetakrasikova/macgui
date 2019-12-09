//
//  DataMatrixTests.swift
//  macguiTests
//
//  Created by Svetlana Krasikova on 12/6/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import XCTest
@testable import macgui

class DataMatrixTests: XCTestCase {
    
    var jsonData = TestDataConstants.matrixJson
    
    override func setUp() {
    }

    func testInitDataMatrixFromJson() {
        XCTAssertNoThrow(try JSONDecoder().decode(DataMatrix.self, from: jsonData))
    }

 

}
