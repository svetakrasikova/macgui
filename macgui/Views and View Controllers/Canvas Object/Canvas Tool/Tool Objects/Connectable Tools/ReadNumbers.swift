//
//  ReadNumbers.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/8/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ReadNumbers: DataTool {

    override var dataToolType: DataTool.DataToolType {
        return .numberData
    }
    
    init(frameOnCanvas: NSRect, analysis: Analysis) {
      
        super.init(name: ToolType.readnumbers.rawValue, frameOnCanvas: frameOnCanvas, analysis: analysis)
        let readnumbers = Connector(type: .readnumbers)
        self.inlets = []
        self.outlets = [readnumbers]
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func openFileBrowser() {
        let panel = NSOpenPanel()
        let textType : UInt32 = UInt32(NSHFSTypeCodeFromFileType("TEXT"))
        panel.allowedFileTypes = [NSFileTypeForHFSTypeCode(textType)]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = true
        panel.begin {
            [unowned self]
            result in
            if result == .OK {
                guard let fileURL = panel.url else { return }
                if !self.numberData.isEmpty {
                    let alert = NSAlert()
                    alert.messageText = "The tool is not empty"
                    alert.informativeText = "Do you want to overwrite the data currently on the tool?"
                    alert.addButton(withTitle: "Cancel")
                    alert.addButton(withTitle: "Overwrite Data")
                    alert.addButton(withTitle: "Load More Data")
                    let result = alert.runModal()
                    switch result {
                    case NSApplication.ModalResponse.alertFirstButtonReturn:
                        return
                    case NSApplication.ModalResponse.alertSecondButtonReturn:
                        self.numberData.emptyList()
                    default:
                        break
                    }
                }
                self.readFromFileURL(fileURL)
            }
        }
    }
    
    
    func readFromFileURL(_ fileURL: URL) {
        
        var successfullyReadData: Bool = true
        var message = ""
        self.delegate?.startProgressIndicator()
        DispatchQueue.global(qos: .background).async {
            do {
                let readData = try self.readNumberDataTask(fileURL)
                if !readData.isEmpty {
                    DispatchQueue.main.async {
                        self.numberData.append(data: readData)
                    }
                }
            }
            catch {
                successfullyReadData = false
                message = "Error reading data from \(fileURL)"
            }
            DispatchQueue.main.async {
                self.delegate?.endProgressIndicator()
                if !successfullyReadData {
                    self.readDataAlert(informativeText: message)
                }
            }
        }
    }
    
    func readNumberDataTask(_ url: URL) throws -> NumberData {
        let numberData = NumberData()
        if url.hasDirectoryPath {
            for fileURL in try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil){
                numberData.append(data: try NumberData(url: fileURL))
            }
        } else {
            numberData.append(data: try NumberData(url: url))
        }

        print(numberData.descriptionString)
        return numberData
    }


}
