import Cocoa



class BinaryController: NSObject {

    var task: Process?
    var outputPipe : Pipe = Pipe()
    var isRunning : Bool = false
    var outputText : String = ""
    var group: DispatchGroup?

     // MARK: -

    func runBinary(binary:String, arguments:[String]) {
        
        isRunning = true
        
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        
        taskQueue.async {
            
            self.task = Process()
            self.task!.launchPath = binary
            self.task!.arguments = arguments
            self.task!.terminationHandler = {
                task in
                DispatchQueue.main.async(execute: {
        
                    self.isRunning = false
                    if let group = self.group {
                        group.leave()
                    }
                    print(self.outputText)
                })
            }
            self.captureStandardOutput(currentTask:self.task!)

            self.task!.launch()

            self.task!.waitUntilExit()
        }
    }

    func captureStandardOutput(currentTask:Process) {
      
        // create a Pipe and attache it to currentTask's standard output
        outputPipe = Pipe()
        currentTask.standardOutput = outputPipe

        // Pipe has two properties: fileHandleForReading and fileHandleForWriting.
        // These are NSFileHandle objects. The fileHandleForReading is used to read
        //the data in the pipe. You call waitForDataInBackgroundAndNotify on it to
        //use a separate background thread to check for available data
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()

        // Whenever data is available, waitForDataInBackgroundAndNotify notifies
        // you by calling the block of code you register with NSNotificationCenter
        // to handle NSFileHandleDataAvailableNotification.
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading , queue: nil) {
            
            notification in

            // get the data as an NSData object and convert it to a string
            let output = self.outputPipe.fileHandleForReading.availableData
            let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""

            // On the main thread, append the string from the previous step to
            // the end of the text in outputText and scrolls the text area so
            // that the user can see the latest output as it arrives. This must
            // be on the main thread, like all UI and user interaction.
            DispatchQueue.main.async(execute: {
                let previousOutput = self.outputText
                let nextOutput = previousOutput + "\n" + outputString
                self.outputText = nextOutput
                //print(self.outputText)
            })

            // Repeat the call to wait for data in the background. This creates
            // a loop that will continually wait for available data, process that
            // data, wait for available data, and so on.
            self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        }
    }

    func pauseBinary() {
    
    }

    func stopBinary() {
    
        if isRunning {
            task!.terminate()
            self.isRunning = false
        }
    }
}
