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
      
   @objc dynamic var dataMatrices: [DataMatrix]  = []
    
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func propagateAlignedData(data: [DataMatrix]){
        if self.outlets.isEmpty {
            self.dataMatrices = data
        } else {
            for connector in self.outlets {
                if let tool = connector.neighbor as? DataTool {
                    tool.propagateAlignedData(data: data)
                }
            }
        }
    }

}
