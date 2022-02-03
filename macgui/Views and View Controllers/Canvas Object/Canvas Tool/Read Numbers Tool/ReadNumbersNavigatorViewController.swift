//
//  ReadNumbersNavigatorViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/13/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ReadNumbersNavigatorViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {

    @IBOutlet weak var outlineView: NSOutlineView!
    
    weak var delegate: ReadNumbersNavigatorViewControllerDelegate?
    
    weak var numberData: NumberData? {
        guard let delegate = self.delegate as? ReadNumbersViewController else {
            return nil
        }
        return delegate.numberData
    }
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        outlineView.reloadData()
        outlineView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
        if let delegate = self.delegate as? ReadNumbersViewController {
            delegate.readNumbersNavigatorViewController(selectedListIndex: 0)
        }
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let listCount = numberData?.numberLists.count {
            return listCount
        }
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return numberData?.numberLists[index] as Any
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, persistentObjectForItem item: Any?) -> Any? {
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let view: NSTableCellView? = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "NumberListCell"), owner: self) as? NSTableCellView
        
        if let numberList = item as? NumberList {
            view?.textField?.stringValue = numberList.name
            view?.imageView?.image = numberListCellImageViewBy(dimension: numberList.dimension)
        }
        return view
    }
    
    func numberListCellImageViewBy(dimension: Int) -> NSImage? {
        let image: NSImage?
        switch dimension {
        case 0: image = NSImage(systemSymbolName: "number", accessibilityDescription: .none)
        case 1: image = NSImage(systemSymbolName: "number.square", accessibilityDescription: .none)
        case 2: image = NSImage(systemSymbolName: "number.square.fill", accessibilityDescription: .none)
        default: image = NSImage(named: "NSActionTemplate")
        }
        return image
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        guard let delegate = self.delegate as? ReadNumbersViewController else {
            return
        }
        let selectedIndex = outlineView.selectedRow
        if selectedIndex >= 0 {
            delegate.readNumbersNavigatorViewController(selectedListIndex: selectedIndex)
        }
        
    }

}

protocol ReadNumbersNavigatorViewControllerDelegate: AnyObject {
    func readNumbersNavigatorViewController(selectedListIndex: Int)
}

