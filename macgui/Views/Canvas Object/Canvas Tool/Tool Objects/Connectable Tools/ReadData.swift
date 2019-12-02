//
//  ReadData.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/6/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa


class ReadData: DataTool {

    let revbayesBridge =  (NSApp.delegate as! AppDelegate).coreBridge
    
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
        
        let green = Connector(color:ConnectorColor.green)
        let blue = Connector(color:ConnectorColor.blue)
        self.inlets = []
        self.outlets = [green, blue]
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func openFileBrowser() {
        let panel = NSOpenPanel()
        let textType : UInt32 = UInt32(NSHFSTypeCodeFromFileType("TEXT"))
        panel.allowedFileTypes = ["nex", "phy", "fasta", "fas", "in", NSFileTypeForHFSTypeCode(textType)]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = true
        panel.begin {
            [unowned self]
            result in
            if result == .OK {
                guard let fileURL = panel.url else { return }
                if !self.dataMatrices.isEmpty{
                    let alert = NSAlert()
                    alert.messageText = "Warning: Do you want to overwrite the data currently on this tool?"
                    alert.informativeText = "Reading in data will delete the information currently on this tool."
                    alert.addButton(withTitle: "Overwrite")
                    alert.addButton(withTitle: "Cancel")
                    let result = alert.runModal()
                           switch result {
                           case NSApplication.ModalResponse.alertFirstButtonReturn:
                            self.dataMatrices = []
                           default: break
                           }
                }
                do {
                    try self.readFromFileURL(fileURL)
                }
                catch {
                
                }
            }
        }
    }
    
    func readFromFileURL(_ fileURL: URL) throws {
            
        // start the progress indicator on the tool
        let group = DispatchGroup()
        DispatchQueue.main.async {
            self.delegate?.startProgressIndicator()
        }

        // read the data on another thread
        let queue = DispatchQueue(label:"Read data queue", qos: .userInitiated)
        var successfullyReadData : Bool = true
        queue.async(group: group) {
            do {
                try self.readDataTask(fileURL)
                }
            catch {
                successfullyReadData = false
            }
        }
        
        // wait here until the read data task is finished
        group.notify(queue: DispatchQueue.main) {
            self.delegate?.endProgressIndicator()
        }
        
        // notify the user if we fail to properly read the data
        if !successfullyReadData {
            readDataAlert()
        }
<<<<<<< HEAD:macgui/Model/Tools/Connectables/ReadData.swift
=======
        //  Add a test matrix here
        let matrix = try! JSONDecoder().decode(DataMatrix.self, from: TestDataConstants.matrixJson)
        self.dataMatrices.append(matrix)

>>>>>>> b0ae5d47b3ff1f99352eae5028c07d58167b9b2d:macgui/Views/Canvas Object/Canvas Tool/Tool Objects/Connectable Tools/ReadData.swift
    }
    
    func readDataTask(_ fileURL: URL) throws {
    
        // obtain a JSON string from the core
        let jsonStringArray : [Any] = revbayesBridge.readMatrix(from: fileURL.path) as! [Any]
        
        // check the array
        if jsonStringArray.count == 0 {
            print("Could not read data from path \(fileURL.path)")
            throw DataToolError.readError
        }
        
        // loop over the json-information stored in the array for each data matrix
        for elem in jsonStringArray {
            do {
                let resultString : String = elem as! String
                print(resultString)
                let data = Data(resultString.utf8)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                let dictionary = json as? [String: Any]
                    
                if let nestedDictionary = dictionary!["CharacterDataMatrix"] as? [String: Any] {
                    do {
                        try self.addMatrix(jsonDictionary:nestedDictionary)
                    }
                    catch {
                        throw DataToolError.readError
                    }
                }
                else {
                    print("Could not read CharacterDataMatrix entry in JSON string")
                    throw DataToolError.jsonError
                }
            }
            catch {
                throw DataToolError.readError
            }
        }
    }

    func readDataAlert() {
        let alert = NSAlert()
        alert.messageText = "Problem Reading Data"
        alert.informativeText = "Data could not be read"
        alert.runModal()
    }
    
    func testFunction() {
    
        print("TestFunction")
    }
    
    
}

