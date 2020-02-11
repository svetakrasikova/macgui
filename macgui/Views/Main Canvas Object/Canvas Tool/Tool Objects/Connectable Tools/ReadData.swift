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
        
        let green = Connector(color:ConnectorType.alignedData)
        let blue = Connector(color:ConnectorType.unalignedData)
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
        
        var readMatrices: [DataMatrix] = []
        var successfullyReadData:Bool = true
        self.delegate?.startProgressIndicator()
        DispatchQueue.global(qos: .background).async {
            do {
                try readMatrices = self.readDataTask(fileURL)
                if !readMatrices.isEmpty {
                    DispatchQueue.main.async {
                        self.dataMatrices = readMatrices
                    }
                }
            }
            catch {
                successfullyReadData = false
            }
            DispatchQueue.main.async {
                self.delegate?.endProgressIndicator()
                if !successfullyReadData {
                    self.readDataAlert()
                }
            }
        }
        
    }
    
    func readDataTask(_ fileURL: URL) throws -> [DataMatrix] {
        var readMatrices: [DataMatrix] = []
        guard let jsonStringArray: [String] = revbayesBridge.readMatrix(from: fileURL.path) as? [String], jsonStringArray.count != 0 else {
            throw ReadDataError.fetchDataError(fileURL: fileURL)
        }
        do {
            let matricesData: [Data] = try JsonCoreBridge(jsonArray: jsonStringArray).encodeMatrixJsonStringArray()
            for data in matricesData {
                do {
                    let newMatrix = try JSONDecoder().decode(DataMatrix.self, from: data)
                    readMatrices.append(newMatrix)
                } catch  {
                    throw ReadDataError.dataDecodingError
                }
            }
        } catch ReadDataError.coreJsonError {
            print("Core JSON data is not well-formatted.")
        }
        return readMatrices
    }

    func readDataAlert() {
        let alert = NSAlert()
        alert.messageText = "Problem Reading Data"
        alert.informativeText = "Data could not be read"
        alert.runModal()
    }
    
}

