//
//  DataMatrixContainer.swift
//  macgui
//
//  Created by John Huelsenbeck on 11/5/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Foundation

@objc class DataMatrixContainer : NSObject {

    var dataMatrices: [DataMatrix]?

    class func create() -> DataMatrixContainer {
    
        return DataMatrixContainer()
    }

}
