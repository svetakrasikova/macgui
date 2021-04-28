//
//  Align.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/6/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Align: DataTool {
    
    enum Method: Int {
        case clustal = 0
        case mafft = 1
        case dialign = 2
        case muscle = 3
        case tcoffee = 4
        case dca = 5
        case probcons = 6
    }
    
    var selectedAlignMethod: Int = Method.clustal.rawValue {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    var clustalOptions: ClustalOmegaOptions? = ClustalOmegaOptions() {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    enum Key: String {
        case clustalOptions, selectedAlignMethod
    }
    
    init(frameOnCanvas: NSRect, analysis: Analysis) {
        super.init(name: ToolType.align.rawValue, frameOnCanvas: frameOnCanvas, analysis: analysis)
        
        let green = Connector(type: ConnectorType.alignedData)
        let blue = Connector(type: ConnectorType.unalignedData)
        inlets = [blue]
        outlets = [green]
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clustalOptions = aDecoder.decodeObject(forKey: Key.clustalOptions.rawValue) as? ClustalOmegaOptions ?? ClustalOmegaOptions()
        selectedAlignMethod = aDecoder.decodeInteger(forKey: Key.selectedAlignMethod.rawValue)
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(clustalOptions, forKey: Key.clustalOptions.rawValue)
        coder.encode(selectedAlignMethod, forKey: Key.selectedAlignMethod.rawValue)
    }
    
    
    func alignMatricesWithClustal (_ data: [DataMatrix], options: ClustalOmegaOptions) throws {
        
        let clustal = RunClustal()
        
        self.delegate?.startProgressIndicator()
        
        let completionHandler = {
            
            [unowned self] in
            
            var successfullyReadData: Bool = true
            
            DispatchQueue.global(qos: .background).async {
                do {
                    let readMatrices = try self.readMatrixDataTask(clustal.exeDirURL)
                    if !readMatrices.isEmpty {
                        DispatchQueue.main.async {
                            self.alignedDataMatrices = readMatrices
                            self.propagateAlignedData(data: readMatrices)
                        }
                        
                    }
                } catch {
                   successfullyReadData = false
                }
                DispatchQueue.main.async {
                    self.delegate?.endProgressIndicator()
                    if !successfullyReadData {
                        self.readDataAlert(informativeText: "Data could not be read")
                    }
                }
            }
            
        }
        
        try clustal.align(dataMatrices: data, options: options, completion: completionHandler)
    }
    
}
