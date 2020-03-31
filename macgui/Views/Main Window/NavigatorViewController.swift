//
//  NavigatorViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/14/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

protocol NavigatorViewControllerDelegate: class {
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
        let selectedRow = analysesTableView.selectedRow
        if selectedRow == -1 { return }
        analyses.remove(at: selectedRow)
        let indexSet = IndexSet(integer: selectedRow)
        analysesTableView.removeRows(at: indexSet, withAnimation:.effectFade)
        if analyses.isEmpty {
            let analysis = Analysis(name: getUniqueAnalysisName(prefix: "untitled analysis", isCopy: false))
            addAnalysis(analysis, row: 0)
        } else {
            analysesTableView.selectRowIndexes(IndexSet(integer: selectedRow-1), byExtendingSelection: false)
        }
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
    
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return analyses.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return analyses[row]
    }
    
    // MARK: - NSTableViewDelegate
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = analysesTableView.selectedRow
        if row >= 0  && analysesTableView.selectedRowIndexes.count == 1  {
            delegate?.navigatorViewController(viewController: self, selectedAnalysis: analyses[row])
        }
    }
}


