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

    
    var tablessViewController: NSTabViewController? {
        return view.window?.contentViewController as? NSTabViewController
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
    

    @IBAction func openSearchOptionsTab(_ sender: NSButton){
        do {
            if let searchTabViewController = self.searchTabViewController, let options = self.options {
                searchTabViewController.selectedTabViewItemIndex = options.searchMethod
            }
            tablessViewController?.selectedTabViewItemIndex = try findSearchTabIndex()
            
        } catch PaupViewControllerError.UndefinedTabIdentifier {
           print("Undefined tab index")
        } catch PaupViewControllerError.TablessViewControllerError {
            print("Undefined Tab Controller")
        } catch {
            print(error)
        }
    }
    
    func findSearchTabIndex() throws -> Int {
        guard let tablessViewController = tablessViewController
        else { throw PaupViewControllerError.TablessViewControllerError }
        
        for (index, tabItem) in tablessViewController.tabViewItems.enumerated() {
            if tabItem.identifier as! String == PaupTablessViewItems.PaupSearch.rawValue {
                return index
            }
        }
        throw PaupViewControllerError.UndefinedTabIdentifier
    }
   

//    @IBAction func reset(_ sender: NSButton) {
//        guard let parsimonyTool = self.tool as? Parsimony else { return }
//        parsimonyTool.options = PaupOptions()
//        self.options = parsimonyTool.options
//        setSearchMethodAt(self.options!.searchMethod)
//        view.needsDisplay = true
//    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if let windowController = view.window?.windowController as? TablessWindowController,  let parsimonyTool = windowController.tool as? Parsimony {
            self.options = parsimonyTool.options
        }
    }

   
    
}
