//
//  ClustalViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/16/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ClustalViewController: NSViewController {
    
    @objc dynamic var options: ClustalOmegaOptions = ClustalOmegaOptions()

    @IBAction func selectDealign(_ sender: NSPopUpButton) {
        if sender.indexOfSelectedItem == 0 {
            self.options.dealign = ClustalOmegaOptions.Dealign.yes
        } else if  sender.indexOfSelectedItem == 1 {
            self.options.dealign = ClustalOmegaOptions.Dealign.no
        }
    }
    @IBAction func selectMBEDGuideTree(_ sender: NSPopUpButton) {
        if sender.indexOfSelectedItem == 0 {
            self.options.mbedClusteringGuideTree = ClustalOmegaOptions.MBEDClusteringGuideTree.yes
        } else if  sender.indexOfSelectedItem == 1 {
            self.options.mbedClusteringGuideTree = ClustalOmegaOptions.MBEDClusteringGuideTree.no
        }
    }
    
    @IBAction func selectMBEDIteration(_ sender: NSPopUpButton) {
           if sender.indexOfSelectedItem == 0 {
               self.options.mbedClusteringIteration = ClustalOmegaOptions.MBEDClusteringIteration.yes
           } else if  sender.indexOfSelectedItem == 1 {
               self.options.mbedClusteringIteration = ClustalOmegaOptions.MBEDClusteringIteration.no
           }
       }
    
    @IBAction func selectOrder(_ sender: NSPopUpButton) {
        if sender.indexOfSelectedItem == 0 {
            self.options.order = ClustalOmegaOptions.Order.aligned
        } else if  sender.indexOfSelectedItem == 1 {
            self.options.order = ClustalOmegaOptions.Order.input
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
