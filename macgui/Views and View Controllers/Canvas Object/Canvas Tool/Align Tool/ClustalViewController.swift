//
//  ClustalViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/16/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ClustalViewController: NSViewController {
    
    @objc dynamic var options: ClustalOmegaOptions?

    @IBAction func selectOrder(_ sender: NSPopUpButton) {
        if sender.indexOfSelectedItem == 0 {
            self.options?.order = ClustalOmegaOptions.Order.aligned
        } else if  sender.indexOfSelectedItem == 1 {
            self.options?.order = ClustalOmegaOptions.Order.input
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
