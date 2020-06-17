import Cocoa



class BinaryController: NSObject {

    var task : Process = Process()
    var outputPipe : Pipe = Pipe()
    var isRunning : Bool = false
    var outputText : String = ""

     // MARK: -

    func runBinary(binary:String, arguments:[String]) {
      
        // set the flag indicating that the process is running
        isRunning = true
        
        // create a DispatchQueue to run the process on a background thread
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        
        // make the DispatchQueue async application will continue to process
        //things like button clicks on the main thread, but the NSTask will
        //run on the background thread until it is complete
        taskQueue.async {

            // Create a new Process object and assign it to the task property.
            // The launchPath property is the path to the executable to be run.
            // Assigns the binary's path to the Process‘s launchPath, then
            // assigns the arguments that are to be passed to the binary.
            // Process will pass the arguments to the executable, as though
            // you had typed them into terminal.
            self.task = Process()
            self.task.launchPath = binary
            self.task.arguments = arguments

            // Process has a terminationHandler property that contains a
            // block which is executed when the task is finished. This
            // updates the UI to reflect that finished status.
            self.task.terminationHandler = {

                task in
                DispatchQueue.main.async(execute: {
                    // complete any UI stuff that should be updated
                    // on completion of the task
                    self.isRunning = false
                    print(self.outputText)
                })
            }

            // output handling
            self.captureStandardOutput(currentTask:self.task)

            // run the binary
            self.task.launch()

            // tell the process object to block any further activity on
            //the current thread until the task is complete
            self.task.waitUntilExit()
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
            task.terminate()
            self.isRunning = false
        }
    }
}
