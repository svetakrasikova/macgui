//
//  filesNavigatorViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/13/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class MatrixNavigatorViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    
    weak var delegate: MatrixNavigatorViewControllerDelegate?
    
    var dataMatrices: [DataMatrix]? {
        guard let delegate = self.delegate as? InspectorViewController else {
            return nil
        }
        return delegate.dataMatrices
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let numberOfRows = dataMatrices?.count else {
            return 0
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let matrixAtRow = dataMatrices?[row]
            else {
            return nil
            }
        return matrixAtRow.matrixName
    }
    
    // MARK: - NSTableViewDelegate
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let dataMatrices = self.dataMatrices else { return }
        let row = tableView.selectedRow
        if row == -1 {
            return
        }
        delegate?.matrixNavigatorViewController(viewController: self, selectedMatrix: dataMatrices[row])
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        tableView.reloadData()
    }

}

protocol MatrixNavigatorViewControllerDelegate: class {
    func matrixNavigatorViewController(viewController: MatrixNavigatorViewController, selectedMatrix: DataMatrix)
}

