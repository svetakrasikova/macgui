import Cocoa



class RunClustal: BinaryController {

     // MARK: -

     enum ClustalError: Error {
     
         case directoryError
         case writeError
    }

     // MARK: -

    func runClustal(fileURL: URL) throws {

//        let options = ClustalOptions()
                
        // create a temporary directory
        let temporaryDirectory = NSTemporaryDirectory()
        var isDirectory = ObjCBool(true)
        let dirExists : Bool = FileManager.default.fileExists(atPath:temporaryDirectory, isDirectory:&isDirectory)
        guard dirExists == true else {
            print("The directory \"\(temporaryDirectory)\" does not exist")
            throw ClustalError.directoryError
        }

        // get all needed file paths and file names
        let dataFileName : String = fileURL.lastPathComponent
        var exeFileURL = URL(fileURLWithPath:temporaryDirectory)
        exeFileURL.appendPathComponent("execute_" + dataFileName)
        var dataFileURL : URL = URL(fileURLWithPath:temporaryDirectory)
        dataFileURL.appendPathComponent(dataFileName)
        let curDataFileURL : URL = fileURL


        // check the file paths
        var fileExists = FileManager.default.fileExists(atPath:exeFileURL.path)
        if fileExists == true {
            print("Overwriting file \"\(exeFileURL.absoluteString)\"")
        }
        fileExists = FileManager.default.fileExists(atPath:dataFileURL.path)
        if fileExists == true {
            print("Overwriting file \"\(dataFileURL.absoluteString)\"")
        }
        fileExists = FileManager.default.fileExists(atPath:curDataFileURL.path)
        if fileExists != true {
            print("Could not find data file at \"\(curDataFileURL.path)\"")
            throw ClustalError.directoryError
        }
                
        // TEMP: write the data matrix to the temporary directory
        var s : String?
        do {
            let d = try Data(contentsOf:curDataFileURL)
            s = String(data:d, encoding: .utf8)
        } catch {
            throw ClustalError.writeError
        }
        do {
            try s!.write(to:dataFileURL, atomically:false, encoding: .utf8)
//            print(s!)
        }
        catch {
            throw ClustalError.writeError
        }

        // get the arguments to be passed to the binary
        let clustalPath : String? = Bundle.main.path(forResource:"clustal", ofType: nil)
        var clustalArgs : [String] = []
        clustalArgs.append("-i")
        clustalArgs.append(dataFileURL.path)
        clustalArgs.append("-o")
        clustalArgs.append(exeFileURL.path)

        
        // run the binary
        self.runBinary(binary:clustalPath!, arguments:clustalArgs)
    }
}
