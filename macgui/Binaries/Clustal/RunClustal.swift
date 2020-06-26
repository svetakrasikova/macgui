import Cocoa



class RunClustal: BinaryController {

     // MARK: -

     enum ClustalError: Error {
     
         case directoryError
         case writeError
    }
    
    var dataFileURL: URL?
    var exeFileURL: URL?
    

     // MARK: -
    
    func createTempDir() throws -> String {
        
        let temporaryDirectory = NSTemporaryDirectory()
        var isDirectory = ObjCBool(true)
        let dirExists : Bool = FileManager.default.fileExists(atPath:temporaryDirectory, isDirectory:&isDirectory)
        guard dirExists == true else {
            print("The directory \"\(temporaryDirectory)\" does not exist")
            throw ClustalError.directoryError
        }
        return temporaryDirectory
    }
    
    func createDataFileURL(dataFileName: String) throws {
        
        let temporaryDirectory = try createTempDir()
        
        var exeFileURL = URL(fileURLWithPath: temporaryDirectory)
        exeFileURL.appendPathComponent("\(dataFileName)_a")
        self.exeFileURL = exeFileURL
        
        var dataFileURL : URL = URL(fileURLWithPath: temporaryDirectory)
        dataFileURL.appendPathComponent(dataFileName)
        self.dataFileURL = dataFileURL

        var fileExists = FileManager.default.fileExists(atPath:exeFileURL.path)
        if fileExists == true {
            print("Overwriting file \"\(exeFileURL.absoluteString)\"")
        }
        fileExists = FileManager.default.fileExists(atPath:dataFileURL.path)
        if fileExists == true {
            print("Overwriting file \"\(dataFileURL.absoluteString)\"")
        }
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

    func runClustal(dataMatrix: DataMatrix, options: ClustalOptions, completion: @escaping () -> Void ) throws {
        
        do {
            try createDataFileURL(dataFileName: dataMatrix.matrixName)
        } catch  {
            throw ClustalError.directoryError
        }
        
        if let dataFileURL = self.dataFileURL, let exeFileURL = self.exeFileURL {
            do {
                try writeMatrixToFastaFile(dataMatrix)
            } catch {
                throw ClustalError.writeError
            }
            
            options.addArgs(inFile: dataFileURL.path, outFile: exeFileURL.path)
           
            
            if !options.args.isEmpty, let clustalPath = Bundle.main.path(forResource:"clustal", ofType: nil) {
            
                self.runBinary(binary: clustalPath, arguments: options.args, completion: completion)
            } else { print("args is empty") }
        }
    }
}
