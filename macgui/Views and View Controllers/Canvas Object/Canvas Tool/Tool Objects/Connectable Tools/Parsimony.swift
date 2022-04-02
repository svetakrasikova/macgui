//
//  Parsimony.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/10/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Parsimony: DataTool, ResolveStateOnExecution {
    
    
    var options: PaupOptions = PaupOptions() {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    override var dataToolType: DataTool.DataToolType {
        return .matrixData
    }
    
    
    enum Key: String {
        case options
    }
        
    init(frameOnCanvas: NSRect, analysis: Analysis) {
        super.init(name: ToolType.parsimony.rawValue, frameOnCanvas: frameOnCanvas, analysis: analysis)
        let green = Connector(type: .alignedData)
        let treedata = Connector(type: .treedata)
        self.inlets = [green]
        self.outlets = [treedata]
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
                            self.propagateData()
                        }
                        
                    }
                } catch {
                   successfullyReadData = false
                }
                DispatchQueue.main.async {
                    self.delegate?.endProgressIndicator()
                    if !successfullyReadData {
                        self.runReadDataAlert(informativeText: "Tree data output from paup could not be read")
                    }
                }
            }
            
        }
        
        try paup.runPaupOnDirectory(dataMatrices: data, options: options, completion: completionHandler)
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


