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
    
    var maxNumberOfCharacters: Int {
        guard let dataMatrices = self.dataMatrices
            else { return 0}
        var max = 0
        for matrix in dataMatrices {
            let currentMax = matrix.numberOfCharactersToInt(numberOfCharacters: matrix.getNumCharacters())
            if currentMax > max {
                max = currentMax
            }
        }
        return max
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
        let row = tableView.selectedRow
        if row == -1 {
            return
        }
        delegate?.matrixNavigatorViewController(selectedMatrixIndex: row)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        tableView.reloadData()
        tableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
        delegate?.matrixNavigatorViewController(selectedMatrixIndex: 0)

    }
    
}

protocol MatrixNavigatorViewControllerDelegate: class {
    func matrixNavigatorViewController(selectedMatrixIndex: Int)
}

