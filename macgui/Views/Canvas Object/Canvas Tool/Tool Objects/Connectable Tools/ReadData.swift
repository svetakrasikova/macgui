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
                self.readFromFileURL(fileURL)
            }
        }
    }
    func readFromFileURL(_ fileURL: URL){
        delegate?.startProgressIndicator()
        let success = revbayesBridge.readMatrix(from: fileURL.path)
        delegate?.endProgressIndicator()
        if !success {
            readDataAlert()
        }
        //  Add a test matrix here
        let matrix = try! JSONDecoder().decode(DataMatrix.self, from: TestDataConstants.matrixJson)
        self.dataMatrices.append(matrix)

    }
    
    func readDataAlert(){
        let alert = NSAlert()
        alert.messageText = "Problem Reading Data"
        alert.informativeText = "Data could not be read"
        alert.runModal()
    }
    
    
}

