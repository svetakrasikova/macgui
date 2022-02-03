import Cocoa



class RunClustal {
    
    var exeDirURL: URL
    var binaryControllers: [BinaryController] = []
    var group: DispatchGroup = DispatchGroup()
    
    init() {
        FileManager.createExeDirForTool(ExecutableTool.clustal.rawValue)
        exeDirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ExecutableTool.clustal.rawValue)
    }
    
    
    func align(dataMatrices: [DataMatrix], options: ClustalOmegaOptions, completion: @escaping ()  -> Void ) throws {
        guard !dataMatrices.isEmpty else {
            throw RunBinaryError.noData
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
        
        let dataFileURL = FileManager.createDataFileURL(dataFileName: dataMatrix.matrixName)
        
        do {
            try dataMatrix.writeFastaFile(dataFileURL: dataFileURL)
        } catch {
            throw RunBinaryError.writeError
        }
        
        guard let clustalPath = Bundle.main.path(forResource: ExecutableTool.clustal.rawValue, ofType: nil) else {
            throw RunBinaryError.launchPathError
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
