//
//  TreeSetToolViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/8/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreeSetToolViewController: InfoToolViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    enum Columns: String {
        case name, count
    }
    
    @IBOutlet weak var inletsTableView: NSTableView!
    
    weak var treeset: TreeSet? {
        return self.tool as? TreeSet
    }
    
    var widthConstraint = NSLayoutConstraint()
    
    @IBOutlet weak var boxView: NSBox!
    
    
    
    func addWidthConstraintToBox(width: CGFloat) {
        removeWidthConstraintFromBox()
        widthConstraint = NSLayoutConstraint(item: boxView as Any,
                                             attribute: NSLayoutConstraint.Attribute.width,
                                             relatedBy: NSLayoutConstraint.Relation.equal,
                                             toItem: nil,
                                             attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                             multiplier: 1,
                                             constant: width)
        boxView.addConstraint(widthConstraint)
    }
    
    func removeWidthConstraintFromBox() {
        boxView.removeConstraint(widthConstraint)
    }
    
    @objc dynamic var sources: [TreeSource] {
        var sources: [TreeSource] = []
        if let treeset = self.treeset {
            sources = treeset.sources
        }
        return sources
    }
    
    @IBAction func controlSources(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment{
        case 0:
            addInlet()
        case 1:
            removeInlet()
        default:
            break
        }
        inletsTableView.reloadData()
        resizeColumnsToFitContent()
    }
    
    func addInlet(){
        self.treeset?.inlets.append(Connector(type: .treedata))
        self.treeset?.sources.append(TreeSource())
        NotificationCenter.default.post(name: .didUpdateAnalysis, object: self)
    }
    
    func removeInlet() {
        
        guard let treeset = self.treeset else { return }
        let row = inletsTableView.selectedRow
        if row >= 0  && inletsTableView.selectedRowIndexes.count == 1  {
            
            if sources[row].key  == "unconnected inlet" {
                var indexToRemove: Int = -1
                for (i,v) in treeset.inlets.enumerated() {
                    if !v.isConnected {
                        indexToRemove = i
                        break
                    }
                }
                if indexToRemove >= 0 {
                    treeset.inlets.remove(at: indexToRemove)
                }
                self.treeset?.sources.remove(at: row)
                
            } else if let tool = sources[row].tool  {
                for connection in self.treeset!.analysis.arrows {
                    if connection.from == tool {
                        if let index = treeset.analysis.arrows.firstIndex(of: connection) {
                            treeset.analysis.arrows.remove(at: index)
                            treeset.removeNeighbor(connectionType: .treedata, linkType: .inlet)
                            tool.removeNeighbor(connectionType: .treedata, linkType: .outlet)
                        }
                        break
                    }
                }
                treeset.removeTreeSource(hash: tool.description.hashValue)
                
            } else {
                treeset.removeTreeSource(hash: sources[row].hashVal)
                
            }
            inletsTableView.removeRows(at: IndexSet(integer: row))
            NotificationCenter.default.post(name: .didUpdateAnalysis, object: self)
        }
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        if tableColumn?.identifier.rawValue == Columns.name.rawValue {
            if let tool = sources[row].tool {
                return tool.name
            } else {
                return sources[row].key
            }
        } else {
            return sources[row].count
        }
    }
    
    
    func resizeColumn(columnName: String) {
        var longest:CGFloat = 0
        let columnNumber = inletsTableView.column(withIdentifier: NSUserInterfaceItemIdentifier(columnName))
        let column = inletsTableView.tableColumns[columnNumber]
        for row in  0..<inletsTableView.numberOfRows {
            let view = inletsTableView.view(atColumn: columnNumber, row: row, makeIfNecessary: true) as! NSTableCellView
            let width = String.lengthOfLongestString([view.textField!.stringValue])
            if (longest < width) {
                longest = width
            }
        }
        
        column.width = longest
        column.minWidth = longest
    }
    
    func resizeColumnsToFitContent() {
        inletsTableView.resizeColumnToFit(columnName: Columns.name.rawValue)
        inletsTableView.resizeColumnToFit(columnName: Columns.count.rawValue)
    }
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        inletsTableView.reloadData()
        resizeColumnsToFitContent()
        addWidthConstraintToBox(width: boxView.fittingSize.width)
        
    }
    @IBAction func okClicked(_ sender: NSButton) {
        postDismissNotification()
    }
    
    @IBAction func importTrees(_ sender: NSButton) {
        
        if let treeset = self.treeset {
            postDismissNotification()
            treeset.delegate?.startProgressIndicator()
            let panel = NSOpenPanel()
            let textType : UInt32 = UInt32(NSHFSTypeCodeFromFileType("TEXT"))
            panel.allowedFileTypes = ["nex", NSFileTypeForHFSTypeCode(textType)]
            panel.allowsMultipleSelection = true
            panel.canChooseDirectories = true
            panel.canChooseFiles = true
            panel.begin {
                result in
                if result == .OK {
                    guard let fileURL = panel.url else { return }
                    treeset.runBackgroundImportTask(url: fileURL)
                }
            }
        }
        
    }
    
}

