//
//  ReadNumbers.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/8/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ReadNumbers: DataTool {

    
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
                if !self.unalignedDataMatrices.isEmpty {
                    let alert = NSAlert()
                    alert.messageText = "Warning: Do you want to overwrite the data currently on this tool?"
                    alert.informativeText = "Reading in data will delete the information currently on this tool."
                    alert.addButton(withTitle: "Overwrite")
                    alert.addButton(withTitle: "Cancel")
                    let result = alert.runModal()
                           switch result {
                           case NSApplication.ModalResponse.alertFirstButtonReturn:
                            self.unalignedDataMatrices = []
                           default: break
                           }
                }
                do {
//                    TODO: code to read in the numbers data
                }
                catch {
                
                }
            }
        }
    }
    


}
