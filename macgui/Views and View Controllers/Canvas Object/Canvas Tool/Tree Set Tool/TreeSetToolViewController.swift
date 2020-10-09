//
//  TreeSetToolViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/8/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreeSetToolViewController: InfoToolViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var inletsTableView: NSTableView!
    
    weak var treeset: TreeSet? {
        return self.tool as? TreeSet
    }
    
    var inlets: [String] {
        return currentInlets()
    }
    
    func currentInlets() -> [String] {
        
        var inlets: [String] = []
        if let treeset = treeset {
            inlets = Array(repeating: "unconnected", count: treeset.unconnectedInlets.count)
            for connection in treeset.analysis.arrows {
                if connection.to === treeset {
                    inlets.append(connection.from.name)
                }
            }
        }
        return  inlets
    }
    
    @IBAction func changeInlets(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment{
        case 0:
            addInlet()
        case 1:
            removeInlet()
        default:
            break
        }
        NotificationCenter.default.post(name: .didUpdateAnalysis, object: self)
    }
    
    func addInlet(){
        self.treeset?.inlets.append(Connector(type: .treedata))
        inletsTableView.reloadData()
    }
    
    func removeInlet() {
        guard let treeset = self.treeset else { return }
        let row = inletsTableView.selectedRow
        if row >= 0  && inletsTableView.selectedRowIndexes.count == 1  {
            
            if inlets[row]  == "unconnected" {
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
            } else {
                let alert = NSAlert()
                alert.messageText = "Connected Inlet"
                alert.informativeText =  "Remove the arrow from canvas."
                alert.runModal()
                
            }
            inletsTableView.removeRows(at: IndexSet(integer: row), withAnimation: .effectFade)
            inletsTableView.reloadData()
        }
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return inlets.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableColumn?.identifier.rawValue == "name" {
            return inlets[row]
        } else {
            return row + 1
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        inletsTableView.reloadData()
        
    }
    @IBAction func okClicked(_ sender: NSButton) {
        postDismissNotification()
    }
    
    @IBAction func importTrees(_ sender: NSButton) {
        postDismissNotification()
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["nex"]
                panel.allowsMultipleSelection = true
                panel.canChooseDirectories = true
                panel.canChooseFiles = true
        panel.begin {
                   [unowned self]
                   result in
                   if result == .OK {
                       guard let fileURL = panel.url else { return }
//                        do something with the trees at the selected url
                   }
               }
        
    }
    
    
    
}

