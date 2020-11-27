//
//  PaupSearchOverviewViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/12/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class PaupSearchOverviewViewController: NSViewController {
   
    
    @objc dynamic var options: PaupOptions?
    
    var summaryViewController: SummaryViewConroller?


    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "SummaryViewController" {
            if let vc = segue.destinationController as? SummaryViewConroller {
                self.summaryViewController = vc
            }
        }
    }
    
    var tablessViewController: NSTabViewController? {
        if let tablessWindowController = view.window?.windowController as? TablessWindowController {
            return tablessWindowController.contentVC
        }
        return nil
    }
    
    var searchTabViewController: NSTabViewController? {
        var tabVC: NSTabViewController?
        if let tabless = self.tablessViewController {
            for tabItem in tabless.tabViewItems {
                if tabItem.identifier as! String == PaupTablessViewItems.PaupSearch.rawValue {
                    tabVC = tabItem.viewController as? NSTabViewController
                }
            }
        }
        return tabVC
    }
    

    @IBAction func selectSearchMethod(_ sender: NSPopUpButton) {
//        preferredContentSize = NSZeroSize
        summaryViewController?.updateSummary()
        print(view.fittingSize.height)
        
    }
    @IBAction func openSearchOptionsTab(_ sender: NSButton){
        
        if let searchTabViewController = self.searchTabViewController, let options = self.options {
            searchTabViewController.selectedTabViewItemIndex = options.searchMethod
        }
        guard let tablessViewController = tablessViewController else { return  }
        
        if let index = tablessViewController.findTabIndexBy(identifierString: PaupTablessViewItems.PaupSearch.rawValue) {
            
            tablessViewController.selectedTabViewItemIndex = index
            
        }
        
        
    }
    
   

//    @IBAction func reset(_ sender: NSButton) {
//        guard let parsimonyTool = self.tool as? Parsimony else { return }
//        parsimonyTool.options = PaupOptions()
//        self.options = parsimonyTool.options
//        setSearchMethodAt(self.options!.searchMethod)
//        view.needsDisplay = true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize =  NSSize(width: 450, height: view.fittingSize.height)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if let windowController = view.window?.windowController as? TablessWindowController,  let parsimonyTool = windowController.tool as? Parsimony {
            self.options = parsimonyTool.options
        }
        self.summaryViewController?.delegate = self


    }
    
    
}


extension PaupSearchOverviewViewController: SummaryViewControllerDelegate {
    
    func summaryType() -> SummaryType {
        switch options?.searchMethod {
        case PaupOptions.SearchMethod.heuristic.rawValue:
            return .heuristicSearch
        case PaupOptions.SearchMethod.exhaustive.rawValue:
            return .exhaustiveSearch
        case PaupOptions.SearchMethod.branchAndBound.rawValue:
            return .branchAndBountSearch
        default:
            break
        }
        return .heuristicSearch
    }
    
    func getSummaryData() -> Any? {
        return options
    }
    
    
}
