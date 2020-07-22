import Cocoa



class RunClustal {
    
    var dataFileURL: URL?
    var exeDirURL: URL
    var binaryControllers: [BinaryController] = []
    var group: DispatchGroup = DispatchGroup()
    
    init() {
        FileManager.createExeDirForTool(ExecutableTool.clustal.rawValue)
        exeDirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ExecutableTool.clustal.rawValue)
    }

    
    func createDataFileURL(dataFileName: String) {
        let temporaryDataDirectory = NSTemporaryDirectory()
        var dataFileURL : URL = URL(fileURLWithPath: temporaryDataDirectory)
        dataFileURL.appendPathComponent(dataFileName)
        self.dataFileURL = dataFileURL
    }
    
    
    func writeMatrixToFastaFile(_ matrix: DataMatrix) throws
    {
        let fastaString: String  = matrix.getFastaString()
        do {
            try fastaString.write(to: dataFileURL!, atomically: false, encoding: .utf8)
        } catch  {
            throw ClustalError.writeError
        }
    }
    
    
    func align(dataMatrices: [DataMatrix], options: ClustalOmegaOptions, completion: @escaping ()  -> Void ) throws {
        guard !dataMatrices.isEmpty else {
            throw ClustalError.noData
        }
        for index in 0..<dataMatrices.count {
            group.enter()
            try runClustal(dataMatrix: dataMatrices[index], options: options)
        }
        group.notify(queue: .main) {
            completion()
        }
    }

    func runClustal(dataMatrix: DataMatrix, options: ClustalOmegaOptions) throws {
        
        createDataFileURL(dataFileName: dataMatrix.matrixName)
        
        if let dataFileURL = self.dataFileURL {
           
            do {
                try writeMatrixToFastaFile(dataMatrix)
            } catch {
                throw ClustalError.writeError
            }
            
            guard let clustalPath = Bundle.main.path(forResource: ExecutableTool.clustal.rawValue, ofType: nil) else {
                           throw ClustalError.launchPathError
                       }
            
            
            let fileName = dataMatrix.matrixName.fileName()
            let outFile = self.exeDirURL.appendingPathComponent(fileName)
            options.addArgs(inFile: dataFileURL.path, outFile: outFile.path)
            
            let process = BinaryController()
            process.group = self.group
            self.binaryControllers.append(process)
            process.runBinary(binary: clustalPath, arguments: options.args)
        }
    }
    
    
    
}
