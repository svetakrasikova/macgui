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
        guard let alignTool = self.tool as? Align else {
            postDismissNotification()
            return
        }
        if let index = tabViewController?.selectedTabViewItemIndex {
            switch index {
            case AlignToolTab.clustal.rawValue:
                if let clustalVC = getTabContentController(index: index) as? ClustalViewController, let matrix = alignTool.unalignedDataMatrices.first{
                    let options = clustalVC.options
                    alignTool.alignMatrixWithClustal(matrix, options: options)
                } else {
                    print("Error: AlignToolViewController can't access clustal or there is no data to be aligned!")
                }
            default:
                print("This alignment method is not implemented yet.")
            }
        }
        postDismissNotification()
    }
   
    @IBAction func resetPushed(_ sender: NSButton) {
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
