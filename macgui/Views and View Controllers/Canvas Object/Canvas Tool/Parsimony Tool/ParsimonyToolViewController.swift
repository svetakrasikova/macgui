//
//  ParsimonyToolViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/12/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ParsimonyToolViewController: InfoToolViewController {

    enum SearchMethod: Int {
        case Exaustive = 0
        case BranchBound = 1
        case Heuristic = 2
    }
    
    @IBAction func selectSearchMethod(_ sender: NSPopUpButton) {
        
        guard let parsimonyTool = self.tool as? Parsimony else { return }
        
        switch sender.indexOfSelectedItem {
        case SearchMethod.Exaustive.rawValue:
            tabViewController?.selectedTabViewItemIndex = SearchMethod.Exaustive.rawValue
            guard let contentVC = getTabContentController(index: SearchMethod.Exaustive.rawValue) as? PaupExhaustiveViewController else { return }
            parsimonyTool.options = contentVC.options
        case SearchMethod.BranchBound.rawValue:
            tabViewController?.selectedTabViewItemIndex = SearchMethod.BranchBound.rawValue
            guard let contentVC = getTabContentController(index: SearchMethod.BranchBound.rawValue) as? PaupBranchBoundViewController else { return }
                parsimonyTool.options = contentVC.options
        case SearchMethod.Heuristic.rawValue:
            tabViewController?.selectedTabViewItemIndex = SearchMethod.Heuristic.rawValue
            guard let contentVC = getTabContentController(index: SearchMethod.Heuristic.rawValue) as? PaupHeuristicViewController else { return }
            parsimonyTool.options = contentVC.options
        default:
            print("Search method not implemented")
            return
        }
    }

    
    override func viewDidLoad() {
           super.viewDidLoad()
       }
    
}
