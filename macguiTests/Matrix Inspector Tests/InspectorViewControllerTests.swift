//
//  InspectorViewControllerTests.swift
//  macguiTests
//
//  Created by Svetlana Krasikova on 11/18/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import XCTest
@testable import macgui

class InspectorViewControllerTests: XCTestCase {
    
    var inspectorVC: InspectorViewController!
    
    override func setUp() {
        super.setUp()
        
        let wc = NSStoryboard.loadWC(StoryBoardName.matrixInspector)
        inspectorVC = wc.contentViewController as? InspectorViewController
        _ = inspectorVC.view
        
        let decoder = JSONDecoder()
        let matrix = try! decoder.decode(DataMatrix.self, from:TestDataConstants.matrixJson)
        inspectorVC.dataMatrices = [matrix]
    }
    
    func test_InspectorViewController_Is_Created() {
        XCTAssertNotNil(inspectorVC)
    }
    
    func test_inspectorViewController_has_matrixNavigator_panel(){
        XCTAssertNotNil(inspectorVC.matrixNavigator)
    }
    
    func test_inspectorViewController_has_matrixViewer_panel(){
        XCTAssertNotNil(inspectorVC.matrixViewer)
    }
    
    func test_inspectorViewController_has_infoInspector_panel(){
        XCTAssertNotNil(inspectorVC.infoInspector)
    }
    
    func test_dataMatrices(){
        let m: DataMatrix = inspectorVC.dataMatrices!.first!
        XCTAssertFalse(inspectorVC.dataMatrices!.isEmpty)
        XCTAssertEqual(m.numTaxa, 4)
    }
    
}
