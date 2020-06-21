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
    
    let revbayesBridge =  (NSApp.delegate as! AppDelegate).coreBridge
      
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
        if self.connectedOutlets.isEmpty  {
            self.dataMatrices += data
        } else {
            for connector in self.outlets {
                if connector.type == .alignedData, let tool = connector.neighbor as? DataTool {
                    tool.propagateAlignedData(data: data)
                }
            }
            self.dataMatrices += data
        }
    }
    
    func readDataTask(_ fileURL: URL) throws -> [DataMatrix] {
          var readMatrices: [DataMatrix] = []
          guard let jsonStringArray: [String] = revbayesBridge.readMatrix(from: fileURL.path) as? [String], jsonStringArray.count != 0 else {
              throw ReadDataError.fetchDataError(fileURL: fileURL)
          }
          do {
              let matricesData: [Data] = try JsonCoreBridge(jsonArray: jsonStringArray).encodeMatrixJsonStringArray()
              for data in matricesData {
                  do {
                      let newMatrix = try JSONDecoder().decode(DataMatrix.self, from: data)
                      readMatrices.append(newMatrix)
                  } catch  {
                      throw ReadDataError.dataDecodingError
                  }
              }
          } catch ReadDataError.coreJsonError {
              print("Core JSON data is not well-formatted.")
          }
          return readMatrices
      }

}
