//
//  Parsimony.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/10/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Parsimony: DataTool, ResolveStateOnExecution {
    
    
    @objc dynamic var trees: [Tree]  = [] {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    var options: PaupOptions = PaupOptions() {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    enum Key: String {
        case options
    }
        
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
        let green = Connector(type: .alignedData)
        let red = Connector(type: .red)
        self.inlets = [green]
        self.outlets = [red]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        options = aDecoder.decodeObject(forKey: Key.options.rawValue) as? PaupOptions ?? PaupOptions()
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(options, forKey: Key.options.rawValue)
    }
    
    
    func createTreesWithPaup (_ data: [DataMatrix], options: PaupOptions) throws {
        
        let paup = RunPaup()
        
        self.delegate?.startProgressIndicator()
        
        let completionHandler = {
            
            [unowned self] in
            
            var successfullyReadData: Bool = true
            
            DispatchQueue.global(qos: .background).async {
                do {
                    let trees = try self.readTreeDataTask(paup.exeDirURL)
                    if !trees.isEmpty {
                        DispatchQueue.main.async {
                            self.trees = trees
                        }
                        
                    }
                } catch {
                   successfullyReadData = false
                }
                DispatchQueue.main.async {
                    self.delegate?.endProgressIndicator()
                    if !successfullyReadData {
                        self.readDataAlert(informativeText: "Tree data output from paup could not be read")
                    }
                }
            }
            
        }
        
        try paup.runPaupOnDirectory(dataMatrices: data, options: options, completion: completionHandler)
    }
    
    
    func readTreeDataTask(_ url: URL) throws -> [Tree] {
        var readTrees: [Tree] = []
        for fileURL in try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil){
            readTrees += try readTreeFile(fileURL)
        }
        return readTrees
    }
    
    func readTreeFile(_ fileURL: URL) throws -> [Tree] {
        var trees: [Tree] = []
        let ns = NewickString()
        do {
            let newickStrings: [String] = try ns.parseNewickStrings(fileURL: fileURL)
            for newickString in newickStrings {
                do {
                    let readTree = try Tree(newickString: newickString)
                    trees.append(readTree)
                } catch {
                    print("Error while parsing a newick string formated file.")
                    throw NewickString.NewickError.fileParsingError
                }
            }
        }
        return trees
    }

    
//    MARK: -- Resolve State on Execution
    
    func execute() {
        do {
            try createTreesWithPaup(self.alignedDataMatrices, options: options)
        } catch  {
            self.delegate?.endProgressIndicator()
            print("Handling exceptions from PAUP not implemented")
        }
    }

}


