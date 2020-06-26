//
//  Align.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/6/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Align: DataTool {
    
    let clustal = RunClustal()
    
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
    
    func alignMatrixWithClustal(_ dataMatrix: DataMatrix, options: ClustalOptions) {

        self.delegate?.startProgressIndicator()
        
        let completionHandler = {
            [unowned self] in
            if let fileURL = self.clustal.exeFileURL {
                
                DispatchQueue.global(qos: .background).async {
                    do {
                        let readMatrices = try self.readDataTask(fileURL)
                        if !readMatrices.isEmpty {
                            DispatchQueue.main.async {
                                self.alignedDataMatrices = readMatrices
                                self.propagateAlignedData(data: readMatrices, isSource: true)
                            }
                            
                        }
                    } catch {
                        print("readDataTask error: \(error)")
                    }
                    DispatchQueue.main.async {
                        self.delegate?.endProgressIndicator()
                    }
                }
                
            }
        }
        
        do {
             try clustal.runClustal(dataMatrix: dataMatrix, options: options, completion: completionHandler)
        } catch  {
            print("runClustal error: \(error)")
        }
           
        
    }
    
    
    
}
