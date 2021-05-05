//
//  NavigatorViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/14/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

protocol NavigatorViewControllerDelegate: AnyObject {
    func navigatorViewController(viewController: NavigatorViewController,
                                 selectedAnalysis: Analysis?) -> Void
}


class NavigatorViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate {
    
    
    @IBOutlet weak var actionButton: NSPopUpButton!
    @IBOutlet weak var analysesTableView: NSTableView!
    
    override var representedObject: Any? {
        didSet {
            analysesTableView.reloadData()
        }
    }
    
    var analyses: [Analysis] {
        get {
            guard let document = self.representedObject as? Document, let analyses = document.dataSource?.analyses else { return [] }
            return analyses
        }
        set {
            guard let document = self.representedObject as? Document else { return }
            document.dataSource?.analyses = newValue
        }
    }
    weak var delegate: NavigatorViewControllerDelegate?
    
    
    @IBAction func removeAnalysisClicked(_ sender: NSPopUpButton) {
        removeSelectedRowsFromAnalyses()
    }
    
    @IBAction func delete(_ sender: AnyObject) {
        removeSelectedRowsFromAnalyses()
    }
    
    @IBAction func addAnalysisClicked(_ sender: NSPopUpButton) {
        let analysis = Analysis(name: getUniqueAnalysisName(prefix: "untitled analysis", isCopy: false))
        var selectedRow = analysesTableView.selectedRow
        if selectedRow == -1 { selectedRow = analyses.count - 1}
        addAnalysis(analysis, row: selectedRow+1)
        
    }
    
    @IBAction func copyAnalysisClicked(_ sender: NSPopUpButton) {
        let selectedRow = analysesTableView.selectedRow
        let selectedAnalysis = analyses[selectedRow]
        if let analysis = selectedAnalysis.copy() as? Analysis {
            let prefix = selectedAnalysis.name
            analysis.name = getUniqueAnalysisName(prefix: prefix, isCopy: true)
            addAnalysis(analysis, row: selectedRow + 1)
        }
        
    }
    
    func addAnalysis(_ analysis: Analysis, row: Int) {
        analyses.insert(analysis, at: row)
        let indexSet = IndexSet(integer: row)
        analysesTableView.insertRows(at: indexSet, withAnimation: .slideDown)
        analysesTableView.selectRowIndexes(indexSet, byExtendingSelection: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        analysesTableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
//        delegate?.navigatorViewController(viewController: self, selectedAnalysis: analyses[0])
    }
    
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return analyses.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return analyses[row]
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        let analysesAsMutableArray = NSMutableArray(array: analyses)
        analysesAsMutableArray.sort(using: analysesTableView.sortDescriptors)
        analyses = analysesAsMutableArray as! [Analysis]
        analysesTableView.reloadData()
    }
    
    // MARK: - NSTableViewDelegate
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = analysesTableView.selectedRow
        if row >= 0  && analysesTableView.selectedRowIndexes.count == 1  {
            delegate?.navigatorViewController(viewController: self, selectedAnalysis: analyses[row])
        }
    }
}


extension NavigatorViewController {
    
    /**
     Create a unique default analysis name starting with prefix followed by the next available numerical identifier
     - parameter prefix: the initial substring of the returned name
     - returns: A unique name for an analysis
     */
    
    
    func getUniqueAnalysisName(prefix: String, isCopy: Bool) -> String {
        var prefixUntilCopy = prefix
        var defaultNameIndices = [Int](repeating: 0, count: analyses.count)
        if let index = prefix.range(of: " copy")?.lowerBound{
            prefixUntilCopy = String(prefix.prefix(upTo: index))
        }
        for analysis in analyses{
            if analysis.name.starts(with: prefixUntilCopy){
                if !isCopy {
                    if analysis.name == prefix {
                        defaultNameIndices[0] = 1
                    } else {
                        if  analysis.name.range(of: "copy") == nil {
                            let numericalIdentifierIndex = (analysis.name.components(separatedBy: " ").count)-1
                            if let index = Int(analysis.name.components(separatedBy: " ")[numericalIdentifierIndex]){
                                if index >= defaultNameIndices.count {
                                    defaultNameIndices.insert(1, at: defaultNameIndices.count)
                                } else {
                                    defaultNameIndices[index] = 1
                                }
                            }
                        }
                    }
                } else {
                    if analysis.name.hasSuffix("copy") ||  analysis.name.range(of: "copy") == nil {
                        defaultNameIndices[0] = 1
                    } else {
                        if  analysis.name.range(of: "copy") != nil {
                            let numericalIdentifierIndex = (analysis.name.components(separatedBy: " ").count)-1
                            if let index = Int(analysis.name.components(separatedBy: " ")[numericalIdentifierIndex]){
                                if index >= defaultNameIndices.count {
                                    defaultNameIndices.insert(1, at: defaultNameIndices.count)
                                } else {
                                    defaultNameIndices[index] = 1
                                }
                            }
                        }
                    }
                }
            }
        }
        if defaultNameIndices.isEmpty || defaultNameIndices[0] == 0 {
            return isCopy ? "\(prefixUntilCopy) copy" : prefix
        }
        for (i,v) in defaultNameIndices.enumerated(){
            if v == 0 {
                return isCopy ? "\(prefixUntilCopy) copy \(i)": "\(prefix) \(i)"
            }
        }
        return isCopy ? "\(prefixUntilCopy) copy \(defaultNameIndices.count)": "\(prefix) \(defaultNameIndices.count)"
    }
}

extension NavigatorViewController {
 
    func removeSelectedRowsFromAnalyses(){
        let selectedRow = analysesTableView.selectedRow
        if selectedRow == -1 { return }
        let indexSet = analysesTableView.selectedRowIndexes
        let count = analysesTableView.selectedRowIndexes.count
        
        let alert = NSAlert()
        alert.messageText = "Warning: Delete Analysis"
        alert.addButton(withTitle: "Delete")
        alert.addButton(withTitle: "Cancel")
        
        if count > 1 {
            alert.informativeText = "You are about to delete \(count) analyses, with all their associated information. Do you wish to continue with this operation?"
        } else {
            alert.informativeText = "You are about to delete an analysis, with all of its associated information. Do you wish to continue with this operation?"
        }
        
        let result = alert.runModal()
        
        switch result {
        case NSApplication.ModalResponse.alertFirstButtonReturn:
            var iteration = 0
            for index in indexSet {
                analyses.remove(at: index-iteration)
                iteration += 1
            }
            analysesTableView.removeRows(at: indexSet, withAnimation:.effectFade)
            
            if analyses.isEmpty {
                let analysis = Analysis(name: getUniqueAnalysisName(prefix: "untitled analysis", isCopy: false))
                addAnalysis(analysis, row: 0)
            } else {
                if let minIndex = indexSet.min() {
                    let selectionIndex = minIndex == 0 ? 0 : minIndex - 1
                    let previousIndexSet = IndexSet(integer: selectionIndex)
                    analysesTableView.selectRowIndexes(previousIndexSet, byExtendingSelection: false)
                }
            }
            
        default: break
            
        }
    }
}


