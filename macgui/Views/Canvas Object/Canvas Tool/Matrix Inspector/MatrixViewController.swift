//
//  MatrixViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/13/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class MatrixViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
   
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var tableHeader: CharacterCellHeaderView!
    
    var taxonData: [String:String]?
    var taxaNames: [String]?

    
    func setTableDataFromMatrix(_ matrix: DataMatrix){
        self.taxaNames = matrix.getTaxaNames()
        var taxonData = [String:String]()
        let activeTaxonNames : [String] = matrix.getActiveTaxaNames()
        for n in activeTaxonNames {
            if let td = matrix.getTaxonData(name: n) {
                taxonData[n] = td.characterDataString()
            }
               }
        self.taxonData = taxonData
    }
    
    
    func showSelectedMatrix(matrixToShow: DataMatrix) {
        setTableDataFromMatrix(matrixToShow)
//        tableHeader.numberOfCharacters = taxonData?.count 
//        tableHeader.needsDisplay = true
        self.tableView.reloadData()

    }
    

    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let numberOfRows = taxonData?.count else {
            return 0
        }
        return numberOfRows
    }
    
    
  // MARK: - NSTableViewDelegate
 

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn = tableColumn else { return nil }
        let taxonName = taxaNames![row]
        if tableColumn.title == "Taxon Name" {
            let cell: NSTableCellView = tableView.makeView(withIdentifier: (NSUserInterfaceItemIdentifier(rawValue: "TaxonNameCell")), owner: self) as! NSTableCellView
            cell.textField?.stringValue = taxonName
            return cell
        } else {
            if let taxonCharacterData = taxonData![taxonName], let cell = tableView.makeView(withIdentifier: (NSUserInterfaceItemIdentifier(rawValue: "CharacterCell")), owner: self) as? CharacterCellView {
                cell.characterString = taxonCharacterData
                autoSizeColumnToFitWidth(column: tableColumn, cell: cell)
                return cell
            }

            return nil
        }
    }
    
    
    func autoSizeColumnToFitWidth(column: NSTableColumn, cell: CharacterCellView) {
        
        let cellWidth = cell.viewSize.width

        if ( column.minWidth < cellWidth )
        {
            column.minWidth = cellWidth
            column.width = cellWidth
        }
    }
    

 

}



