//
//  AlignToolViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/15/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class AlignToolViewController: InfoToolViewController {
    
    var alignTool: Align? {
        return tool as? Align
    }
    
    var selectedTabIndex: Int {
        self.alignTool?.selectedAlignMethod ?? 0
    }
    
    var clustalVC: ClustalViewController? {
        return getTabContentController(index: Align.Method.clustal.rawValue) as? ClustalViewController
    }
    
    @IBAction func cancelPushed(_ sender: NSButton) {
        writeOptionsToTool()
        postDismissNotification()
    }
    
    @IBAction func okPushed(_ sender: NSButton) {
        writeOptionsToTool()
        
        if let index = tabViewController?.selectedTabViewItemIndex {
            switch index {
            case Align.Method.clustal.rawValue:
                alignWithClustal()
            default:
                print("This alignment method is not implemented yet.")
            }
        }
        postDismissNotification()
    }
    
    
     @IBAction func resetPushed(_ sender: NSButton) {
         runResetAlert()
     }
    
    func runResetAlert(){
        let alert = NSAlert()
        alert.messageText = "Warning: you are about to remove aligned data and reset selected options to default."
        alert.addButton(withTitle: "Reset")
        alert.addButton(withTitle: "Cancel")
        let result = alert.runModal()
        switch result {
        case NSApplication.ModalResponse.alertFirstButtonReturn:
            self.alignTool?.alignedDataMatrices.removeAll()
            switch tabViewController?.selectedTabViewItemIndex {
            case Align.Method.clustal.rawValue:
                clustalVC?.options =  ClustalOmegaOptions()
                view.needsDisplay = true
            default: break
            }
        default: break
        }
    }
     
    
    func alignWithClustal() {

        if let options = self.clustalVC?.options, let alignTool = self.alignTool {
            do {
                try alignTool.alignMatricesWithClustal(alignTool.dataMatrices, options: options)
            } catch RunBinaryError.noData {
                let message = "There is no data to run alignment on"
                runAlignmentAlert(tool: ExecutableTool.clustal.rawValue, informativeText: message)
                alignTool.delegate?.endProgressIndicator()
            } catch RunBinaryError.writeError {
                print("ClustalError.writeError: error writing data in fasta format to temp directory")
                alignTool.delegate?.endProgressIndicator()
            } catch RunBinaryError.launchPathError {
                print("ClustalError.launchPathError: wrong path to the binary")
                alignTool.delegate?.endProgressIndicator()
            } catch {
                print("Clustal error: \(error)")
                alignTool.delegate?.endProgressIndicator()
            }
        }
        
    }
    
    func runAlignmentAlert(tool: String, informativeText: String) {
        let alert = NSAlert()
        alert.messageText = "Problem running alignment with \(tool)"
        alert.informativeText =  informativeText
        alert.runModal()
    }
   
    func writeOptionsToTool(){
        self.alignTool?.clustalOptions = self.clustalVC?.options
        alignTool?.selectedAlignMethod = tabViewController?.selectedTabViewItemIndex ?? 0
    }
    
    func readOptionsFromTool() {
        self.clustalVC?.options = self.alignTool?.clustalOptions
        tabViewController?.selectedTabViewItemIndex = selectedTabIndex
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        readOptionsFromTool()
        tabViewController?.selectedTabViewItemIndex = selectedTabIndex
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        writeOptionsToTool()
       
        
    }

    
}
