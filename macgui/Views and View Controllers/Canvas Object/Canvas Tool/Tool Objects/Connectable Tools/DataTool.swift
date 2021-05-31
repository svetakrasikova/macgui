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
        case trees
        case numberData
    }
    
    enum DataToolType: String {
        case treeData, matrixData, numberData, genericData
    }
    
    let revbayesBridge =  (NSApp.delegate as! AppDelegate).coreBridge
    
    @objc dynamic var trees: [Tree]  = [] {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    var dataToolType: DataToolType {
        return .genericData
    }
    
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
    
    @objc dynamic var numberData: NumberData = NumberData() {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    
    
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(alignedDataMatrices, forKey: Key.alignedDataMatrices.rawValue)
        aCoder.encode(unalignedDataMatrices, forKey: Key.unalignedDataMatrices.rawValue)
        aCoder.encode(trees, forKey: Key.trees.rawValue)
        aCoder.encode(numberData, forKey: Key.numberData.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        alignedDataMatrices = aDecoder.decodeObject(forKey: Key.alignedDataMatrices.rawValue) as? [DataMatrix] ?? []
        unalignedDataMatrices = aDecoder.decodeObject(forKey: Key.unalignedDataMatrices.rawValue) as? [DataMatrix] ?? []
        trees = aDecoder.decodeObject(forKey: Key.trees.rawValue) as? [Tree] ?? []
        numberData = aDecoder.decodeObject(forKey: Key.numberData.rawValue) as? NumberData ?? NumberData()
    }
    
    
    func propagateAlignedData(data: [DataMatrix] = []){
        self.alignedDataMatrices = data
        if !self.connectedOutlets.isEmpty  {
            for connection in self.analysis.arrows {
                if connection.type == .alignedData, connection.from === self, let neighbor = connection.to as? DataTool {
                    neighbor.propagateAlignedData(data: data)
                }
            }
            
        }
    }
    
    func propagateUnalignedData(data: [DataMatrix] = []){
        self.unalignedDataMatrices = data
        if !self.connectedOutlets.isEmpty  {
            for connection in self.analysis.arrows {
                if connection.type == .alignedData, connection.from === self, let neighbor = connection.to as? DataTool {
                    neighbor.propagateUnalignedData(data: data)
                }
            }
        }
    }
    
    func propagateTreeData(data: [Tree] = [], source: DataTool, removeSource: Bool) {
        
        if data.isEmpty, let treeset = self as? TreeSet {
            let hash = source.description.hashValue
            if removeSource {
                treeset.removeTreeSource(hash: hash)
            } else {
                treeset.emptyTreeSource(hash: hash)
            }
        } else if !data.isEmpty, let treeset = self as? TreeSet {
//            TODO: write the trees to the trees on the treeset tool

        }  else {
            
            self.trees = data
            if !self.connectedOutlets.isEmpty  {
                for connection in self.analysis.arrows {
                    if connection.from === self, let neighbor = connection.to as? DataTool {
                        neighbor.propagateTreeData(data: data, source: self, removeSource: removeSource)
                    }
                }
            }
        }
        
    }
    
    
    func connectAlignedData(from: DataTool) {
        let alignedMatrices =  from.dataMatrices.filter{$0.homologyEstablished == true}
        if !alignedMatrices.isEmpty {
            propagateAlignedData(data: alignedMatrices)
        }
    }
    
    func connectUnalignedData(from: DataTool) {
        let unalignedMatrices =  from.dataMatrices.filter{$0.homologyEstablished == false}
        if !unalignedMatrices.isEmpty {
            propagateUnalignedData(data: unalignedMatrices)
        }
    }
    
    func propagateData() {
        let unalignedData = self.unalignedDataMatrices.filter{$0.homologyEstablished == false}
        let alignedData = self.alignedDataMatrices + unalignedDataMatrices.filter{$0.homologyEstablished == true}
        for connection in self.analysis.arrows {
            if connection.type == .alignedData, connection.from === self, let neighbor = connection.to as? DataTool {
                neighbor.propagateAlignedData(data: alignedData)
                neighbor.propagateTreeData(source: self, removeSource: false)
            } else if connection.type == .unalignedData, connection.from === self, let neighbor = connection.to as? DataTool {
                neighbor.propagateUnalignedData(data: unalignedData)
                neighbor.propagateTreeData(source: self, removeSource: false)
            }
        }
    }
    
    func readMatrixDataTask(_ fileURL: URL) throws -> [DataMatrix] {
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
    
    func readTreeFile(_ fileURL: URL) throws -> [Tree] {
        var trees: [Tree] = []
        do {
            let newickStrings: [String] = try NewickString.parseNewickStrings(fileURL: fileURL)
            for newickString in newickStrings {
                do {
                    let readTree = try Tree(newickString: newickString)
                    trees.append(readTree)
                } catch {
                    print("Error while creating a tree from a newick string: \(error)")
                    throw Tree.TreeError.badNewickString
                }
            }
        } catch {
            print("Error while parsing a newick string formated file: \(error)")
            throw NewickString.NewickError.fileParsingError
        }
        return trees
    }
    
    func readTreeDataTask(_ url: URL) throws -> [Tree] {
        var readTrees: [Tree] = []
        if url.hasDirectoryPath {
            for fileURL in try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil){
                readTrees += try readTreeFile(fileURL)
            }
        } else {
            readTrees += try readTreeFile(url)
        }
        return readTrees
    }
    
    
    func readDataAlert(informativeText: String) {
        let alert = NSAlert()
        alert.messageText = "Problem Reading Data"
        alert.informativeText =  informativeText
        alert.runModal()
    }
    
}
