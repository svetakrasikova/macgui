//
//  PaupSearchOverviewViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/12/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class PaupOverviewViewController: NSViewController {
    
    
    @IBOutlet var criterionPopup: NSPopUpButton!
    
    @IBOutlet var searchMethodPopup: NSPopUpButton!
    
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
    
    
    var type: String? {
        
        if let tabless = self.tablessViewController {
            
            if let overviewTab = tabless.tabViewItems[tabless.selectedTabViewItemIndex].viewController as? NSTabViewController {
                
                let selectedOverviewTabID =  overviewTab.tabViewItems[overviewTab.selectedTabViewItemIndex].identifier
                
                if selectedOverviewTabID as! String == PaupTablessViewItems.PaupSearch.rawValue {
                    
                    return PaupTablessViewItems.PaupSearch.rawValue
                    
                } else if selectedOverviewTabID as! String == PaupTablessViewItems.PaupCriterion.rawValue {
                    return PaupTablessViewItems.PaupCriterion.rawValue
                    
                }
            }
        }
        return nil
    }
    
    
    var selectedOptionsViewController: NSTabViewController? {
        
        if let tabless = self.tablessViewController, let type = self.type {
            
            if type == PaupTablessViewItems.PaupSearch.rawValue {
                
                return tabless.tabViewItems.filter {$0.identifier as! String ==  PaupTablessViewItems.PaupSearch.rawValue  }.first?.viewController as? NSTabViewController
                
            } else if type == PaupTablessViewItems.PaupCriterion.rawValue {
                
                return tabless.tabViewItems.filter {$0.identifier as! String ==  PaupTablessViewItems.PaupCriterion.rawValue  }.first?.viewController as? NSTabViewController
            }
        }
        return nil
    }
    
    
    
    @IBAction func selectKeyOption(_ sender: NSPopUpButton) {
        summaryViewController?.updateSummary()
        
    }
    
    @IBAction func openOptionsTab(_ sender: NSButton){

        if let selectedOptionsViewController = self.selectedOptionsViewController, let options = self.options {
            
            switch self.type {
            
            case PaupTablessViewItems.PaupSearch.rawValue:
                
                selectedOptionsViewController.selectedTabViewItemIndex = options.searchMethod
                
                if let index = self.tablessViewController?.findTabIndexBy(identifierString: PaupTablessViewItems.PaupSearch.rawValue) {
                    tablessViewController?.selectedTabViewItemIndex = index
                }
                
            case PaupTablessViewItems.PaupCriterion.rawValue:
                
                selectedOptionsViewController.selectedTabViewItemIndex = options.criterion
                
                if let index = tablessViewController?.findTabIndexBy(identifierString: PaupTablessViewItems.PaupCriterion.rawValue) {
                    tablessViewController?.selectedTabViewItemIndex = index
                    
                }
            default: break
                
            }
        }
        
    }
    
    
    @IBAction func reset(_ sender: NSButton) {
        if let tablessWindowController = view.window?.windowController as? TablessWindowController, let parsimony = tablessWindowController.tool as? Parsimony, let options = self.options {
            
            if self.type == PaupTablessViewItems.PaupSearch.rawValue {
                parsimony.options.revertSearchToFactorySettings()
                searchMethodPopup.selectItem(at: options.searchMethod)
            } else {
                parsimony.options.revertCriterionToFactorySettings()
                criterionPopup.selectItem(at: options.criterion)
            }
            
        }
        summaryViewController?.updateSummary()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize =  NSSize(width: 450, height: view.fittingSize.height)
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.summaryViewController?.delegate = self
        if let tablessWindowController = view.window?.windowController as? TablessWindowController, let parsimony = tablessWindowController.tool as? Parsimony {
            self.options = parsimony.options
        }
        self.summaryViewController?.updateSummary()
        
    }

}


extension PaupOverviewViewController: SummaryViewControllerDelegate {
    
    func searchSummaryType() -> SummaryType {
        switch options?.searchMethod {
        case PaupOptions.SearchMethod.heuristic.rawValue:
            return .heuristicSearch
        case PaupOptions.SearchMethod.exhaustive.rawValue:
            return .exhaustiveSearch
        case PaupOptions.SearchMethod.branchAndBound.rawValue:
            return .branchAndBoundSearch
        default:
            break
        }
        return .heuristicSearch
    }
    func criterionSummaryType() -> SummaryType {
        switch options?.criterion {
        case PaupOptions.Criteria.parsimony.rawValue:
            return .parsimony
        case PaupOptions.Criteria.likelihood.rawValue:
            return .likelihood
        case PaupOptions.Criteria.distance.rawValue:
            return .distance
        default:
            break
        }
        return .parsimony
    }
    
    
    func summaryType() -> SummaryType {
        if let type = self.type {
            if type == PaupTablessViewItems.PaupCriterion.rawValue {
                return criterionSummaryType()
            } else {
                return searchSummaryType()
            }
        }
        return .data
    }
    
    func getSummaryData() -> Any? {
        return options
    }
    
    
}
