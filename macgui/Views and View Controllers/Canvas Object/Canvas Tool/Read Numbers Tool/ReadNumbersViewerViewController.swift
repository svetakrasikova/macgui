//
//  ReadNumbersViewerViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/13/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa


class ReadNumbersViewerViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    weak var delegate: ReadNumbersNavigatorViewControllerDelegate?
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var dimensionLabel: NSTextField!
    @IBOutlet weak var listNameLabel: NSTextField!
    @IBOutlet weak var typePopup: NSPopUpButton!
    
    enum TableViewColumn: String {
        case NumberList
    }
    
    @objc dynamic var numberList: NumberList? {
        didSet {
            dimensionLabel.stringValue = numberList?.dimensionSymbolWithoutType ?? ""
        }
    }
    
    @objc dynamic var enableTypeSelection: Bool {
        guard let list = numberList else { return true }
        return !list.observed
    }

    func showSelectedNumberData(listIndex: Int) {
        guard let delegate = self.delegate as? ReadNumbersViewController else { return }
        numberList = delegate.numberData?.numberLists[listIndex]
        tableView.reloadData()
        tableView.resizeColumnToFit(columnName: TableViewColumn.NumberList.rawValue)
        setUpTypePopup()
        view.needsDisplay = true
    }
 
//    MARK: -- NSTableViewDataSourceDelegate
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let numberList = self.numberList else { return 0 }
        return numberList.valueList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
       
        guard tableColumn?.identifier.rawValue == TableViewColumn.NumberList.rawValue else { return nil }
        guard let list = self.numberList else { return nil }
        
        let str = list.stringValue(index: row)
        if let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "NumberListCell"), owner: self) as? NSTableCellView {
            cellView.textField?.stringValue = str
            return cellView
        }
        return nil
    }
//  MARK: -- Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTypePopup()
    }
    


    override func viewDidAppear() {
        super.viewDidAppear()
        typePopup.bind(.enabled, to: self, withKeyPath: "enableTypeSelection", options: [:])
    }
    
//    MARK: -- UI elements
    
    func setUpTypePopup() {
        typePopup.removeAllItems()
        for type in NumberListType.allCases {
            typePopup.addItem(withTitle: type.rawValue)
        }
        if let type = self.numberList?.type, let selectedItem = typePopup.item(withTitle: type.rawValue) {
            typePopup.select(selectedItem)
            let compatibleTypes = NumberList.typesCompatibleWith(type)
            for title in typePopup.itemTitles {
                guard let t = NumberListType(rawValue: title)
                else {
                    return
                }
                let item = typePopup.item(withTitle: title)
                item?.isEnabled = compatibleTypes.contains(t) ? true : false
            }
        }
    }
    
    @IBAction func typeSelected(_ sender: NSPopUpButton) {
        switch sender.selectedItem?.title {
        case NumberListType.Integer.rawValue:
            self.numberList?.type = NumberListType.Integer
        case NumberListType.Natural.rawValue:
            self.numberList?.type = NumberListType.Natural
        case NumberListType.Real.rawValue:
            self.numberList?.type = NumberListType.Real
        case NumberListType.RealPos.rawValue:
            self.numberList?.type = NumberListType.RealPos
        case NumberListType.Simplex.rawValue:
            self.numberList?.type = NumberListType.Simplex
        default: break
        }
    }
    
        
}
