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
    
    enum Key: String {
        case alignedDataMatrices
        case unalignedDataMatrices
    }
    
    let revbayesBridge =  (NSApp.delegate as! AppDelegate).coreBridge
    
    @objc dynamic var alignedDataMatrices: [DataMatrix]  = [] {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    @objc dynamic var unalignedDataMatrices: [DataMatrix]  = []  {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    @objc dynamic var dataMatrices: [DataMatrix]  {
        return !alignedDataMatrices.isEmpty ? alignedDataMatrices : unalignedDataMatrices
    }
    
    
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(alignedDataMatrices, forKey: Key.alignedDataMatrices.rawValue)
        aCoder.encode(unalignedDataMatrices, forKey: Key.unalignedDataMatrices.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        alignedDataMatrices = aDecoder.decodeObject(forKey: Key.alignedDataMatrices.rawValue) as! [DataMatrix]
        unalignedDataMatrices = aDecoder.decodeObject(forKey: Key.unalignedDataMatrices.rawValue) as! [DataMatrix]
    }
    
    func propagateAlignedData(data: [DataMatrix] = [], isSource: Bool){
        if self.connectedOutlets.isEmpty  {
            self.alignedDataMatrices = data
        } else {
            
            for connection in self.analysis.arrows {
                if connection.type == .alignedData, connection.from === self, let neighbor = connection.to as? DataTool {
                    neighbor.propagateAlignedData(data: data, isSource: false)
                }
            }
            
            if !isSource { self.alignedDataMatrices = data }
        }
    }
    
    func propagateUnalignedData(data: [DataMatrix] = [], isSource: Bool){
        if self.connectedOutlets.isEmpty  {
            self.unalignedDataMatrices = data
            self.alignedDataMatrices.removeAll()
        } else {
            for connection in self.analysis.arrows {
                if connection.type == .alignedData, connection.from === self, let neighbor = connection.to as? DataTool {
                    neighbor.propagateUnalignedData(data: data, isSource: false)
                }
            }
            if !isSource {
                self.unalignedDataMatrices = data
                self.alignedDataMatrices.removeAll()
            }
        }
    }
    
    func connectAlignedData() throws {
        
        if !dataMatrices.isEmpty {
            let alignedMatrices =  dataMatrices.filter{$0.homologyEstablished == true}
            if alignedMatrices.isEmpty {
                throw ConnectionError.noAlignedData
            } else {
                propagateAlignedData(data: alignedMatrices, isSource: true)
            }
        } else {
            throw ConnectionError.noData
        }
    }
    
    func connectUnalignedData() throws {
        if dataMatrices.isEmpty {
            propagateUnalignedData(data: dataMatrices, isSource: true)
            
        } else {
            throw ConnectionError.noData
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
            print("JSON data is not well-formatted.")
        }
        return readMatrices
    }
    
    func readDataAlert(informativeText: String) {
        let alert = NSAlert()
        alert.messageText = "Problem Reading Data"
        alert.informativeText =  informativeText
        alert.runModal()
    }
    
}
