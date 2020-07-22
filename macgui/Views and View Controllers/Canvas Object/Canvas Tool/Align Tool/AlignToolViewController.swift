//
//  AlignToolViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/15/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class AlignToolViewController: InfoToolViewController {
    
    enum AlignToolTab: Int {
        case clustal = 0
        case mafft = 1
        case dialign = 2
        case muscle = 3
        case tcoffee = 4
        case dca = 5
        case probcons = 6
    }
    
    
    var tabViewController: NSTabViewController?
    

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TabViewController")
        { tabViewController = (segue.destinationController as! NSTabViewController) }    }
    
    
    @IBAction func cancelPushed(_ sender: NSButton) {
        postDismissNotification()
    }
    
    @IBAction func okPushed(_ sender: NSButton) {
        guard let alignTool = self.tool as? Align else { return }
        if let index = tabViewController?.selectedTabViewItemIndex {
            switch index {
            case AlignToolTab.clustal.rawValue:
                alignWithClustal(alignTool)
            default:
                print("This alignment method is not implemented yet.")
            }
        }
        postDismissNotification()
    }
    
    func alignWithClustal(_ alignTool: Align) {
        guard let clustalVC = getTabContentController(index: AlignToolTab.clustal.rawValue) as? ClustalViewController else { return }
       
        
        let options = clustalVC.options
        
        do {
            try alignTool.alignMatricesWithClustal(alignTool.dataMatrices, options: options)
        } catch ClustalError.noData {
            let message = "There is no data to run alignment on"
            runAlignmentAlert(tool: ExecutableTool.clustal.rawValue, informativeText: message)
        } catch ClustalError.writeError {
            print("ClustalError.writeError: error writing data in fasta format to temp directory")
        } catch ClustalError.launchPathError {
            print("ClustalError.launchPathError: wrong path to the binary")
        } catch {
            print("Clustal error: \(error)")
        }
        
    }
    
    func runAlignmentAlert(tool: String, informativeText: String) {
        let alert = NSAlert()
        alert.messageText = "Problem running alignment with \(tool)"
        alert.informativeText =  informativeText
        alert.runModal()
    }
   
    @IBAction func resetPushed(_ sender: NSButton) {
        guard let alignTool = self.tool as? Align else { return }
        alignTool.alignedDataMatrices.removeAll()
        postDismissNotification()
    }
    
    func postDismissNotification() {
       NotificationCenter.default.post(name: .dismissToolSheet, object: self)
    }
    
    func getTabContentController(index: Int) -> NSViewController? {
        return tabViewController?.tabViewItems[index].viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    
}
