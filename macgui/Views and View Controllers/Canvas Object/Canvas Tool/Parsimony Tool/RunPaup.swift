//
//  RunPaup.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/12/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class RunPaup {
    
    var exeDirURL: URL
    var binaryControllers: [BinaryController] = []
    var group: DispatchGroup = DispatchGroup()
    
    init() {
        FileManager.createExeDirForTool(ExecutableTool.paup.rawValue)
        exeDirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ExecutableTool.paup.rawValue)
    }
    
    
    func runPaupOnDirectory(dataMatrices: [DataMatrix], options: PaupOptions, completion: @escaping ()  -> Void ) throws {
        guard !dataMatrices.isEmpty else {
            throw RunBinaryError.writeError
        }
        for index in 0..<dataMatrices.count {
            group.enter()
            try runPaup(dataMatrix: dataMatrices[index], options: options)
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func runPaup(dataMatrix: DataMatrix, options: PaupOptions) throws {
        
        guard let paupPath = Bundle.main.path(forResource: ExecutableTool.paup.rawValue, ofType: nil) else {
                 throw RunBinaryError.launchPathError
             }
        
        let dataFileURL = FileManager.createDataFileURL(dataFileName: dataMatrix.matrixName)
        
        do {
            try dataMatrix.writeNexusFile(dataFileURL: dataFileURL)
        } catch {
            throw RunBinaryError.writeError
        }
        
        do {
            let exeFilePath = try createExeScript(dataMatrix: dataMatrix, options: options)
            let process = BinaryController()
            process.group = self.group
            self.binaryControllers.append(process)
            process.runBinary(binary: paupPath, arguments: [exeFilePath])
                   
        } catch  {
            throw RunBinaryError.writeError
        }
        
    }
    
    func createExeScript(dataMatrix: DataMatrix, options: PaupOptions) throws -> String {
      
        let fileName: String = dataMatrix.matrixName.fileName()
        let dataFileURL: URL  =  FileManager.createDataFileURL(dataFileName: dataMatrix.matrixName)
        let exeFileURL: URL = FileManager.createExeScript(dataFileName: fileName)
        let outputFileURL: URL = self.exeDirURL.appendingPathComponent(fileName)
        
        
        let paupBlock: String = """
        begin paup;
            \(options.setString())
            execute \(dataFileURL.path);
            \(options.methodsAssumptionsString())
            \(options.searchMethodString())
            Savetrees file=\(outputFileURL.path) format=altNexus replace=yes;
            quit;
        end;
        """
        
        let assumptionsBlock: String = """
        begin assumptions;
            \(options.stepMatrixString())
        end;
        """
        
        let scriptContents: String = options.psStepMatrix == PaupOptions.PSStepMatrix.no.rawValue ?  paupBlock : "\(paupBlock)\n\(assumptionsBlock)"
    
    
        let data = NSData(data: scriptContents.data(using:String.Encoding.utf8, allowLossyConversion:false)!)
        do {
            try data.write(to: exeFileURL, options: .atomic)
        }
        catch {
            throw RunBinaryError.writeError
        }
        
        return exeFileURL.path
    }
    
}
