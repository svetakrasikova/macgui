//
//  Align.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/6/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Align: DataTool {
    
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
        
        let green = Connector(color:ConnectorType.alignedData)
        let blue = Connector(color: ConnectorType.unalignedData)
        inlets = [blue]
        outlets = [green]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func alignMatricesWithClustal (_ data: [DataMatrix], options: ClustalOmegaOptions) throws {
        
        let clustal = RunClustal()
        
        self.delegate?.startProgressIndicator()
        
        let completionHandler = {
            
            [unowned self] in
            
            var successfullyReadData: Bool = true
            
            DispatchQueue.global(qos: .background).async {
                do {
                    let readMatrices = try self.readDataTask(clustal.exeDirURL)
                    if !readMatrices.isEmpty {
                        DispatchQueue.main.async {
                            self.alignedDataMatrices = readMatrices
                            self.propagateAlignedData(data: readMatrices, isSource: true)
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
