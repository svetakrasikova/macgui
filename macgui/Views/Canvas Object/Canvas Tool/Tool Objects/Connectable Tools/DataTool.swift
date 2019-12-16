//
//  DataTool.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/25/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class DataTool: Connectable {

   enum DataToolError: Error {
          
          case readError
          case jsonError
      }
      
   var dataMatrices: [DataMatrix]  = [] {
          didSet {
              if dataMatrices.isEmpty {
                  NotificationCenter.default.post(name: .didUpdateDataMatrices, object: nil, userInfo: ["isEmpty" : true])
              } else {
                  NotificationCenter.default.post(name: .didUpdateDataMatrices, object: nil, userInfo: ["isEmpty" : false])
              }

          }
      }
    
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
