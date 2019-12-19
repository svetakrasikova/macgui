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
   
    var taxonData: [String:String]?
    var taxaNames: [String]?
    var numberOfCharacterColumns: Int = 0
    
    
    var tableViewColumnsArray: [ColumnDictionary] = []
    let columnDefaultWidth:Float = 100.0
    

    func populateTableViewColumnsArray() {
        if tableViewColumnsArray.isEmpty {
            self.tableViewColumnsArray.append(ColumnDictionary(identifier: "Taxon Name", title: "Taxon Name", type: "text", maxWidth: 80.0, minWidth: 100.0))
            for index in 1..<(numberOfCharacterColumns+1) {
                self.tableViewColumnsArray.append(ColumnDictionary(identifier: "\(index)", title: "\(index)", type: "text", maxWidth: 20.0, minWidth: 20.0))
            }
        } else {
            let numberCharacterColumns = tableViewColumnsArray.count - 1
            if numberCharacterColumns < self.numberOfCharacterColumns {
                for index in numberCharacterColumns..<(self.numberOfCharacterColumns+1) {
                    self.tableViewColumnsArray.append(ColumnDictionary(identifier: "\(index)", title: "\(index)", type: "text", maxWidth: 20.0, minWidth: 20.0))
                }
            }
            
        }
    }
    
    func flushTableView(){
        taxonData = [:]
        self.tableView.reloadData()
    }
    
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
        self.numberOfCharacterColumns = matrix.numberOfCharactersToInt(numberOfCharacters: matrix.getNumCharacters())
    }
    
    func showSelectedMatrix(matrixToShow: DataMatrix) {
        setTableDataFromMatrix(matrixToShow)
        populateTableViewColumnsArray()
        addMatrixDataColumnsToTableView()
//        figure out how to reload only visible cells
        self.tableView.reloadData()

    }

    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let numberOfRows = taxonData?.count else {
            return 0
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return nil
    }
    
  // MARK: - NSTableViewDelegate
 

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn = tableColumn else { return nil }
        let cell: NSTableCellView = tableView.makeView(withIdentifier: (NSUserInterfaceItemIdentifier(rawValue: "CharacterCell")), owner: self) as! NSTableCellView
        let taxonName = taxaNames![row]
        if tableColumn.title == "Taxon Name" {
            cell.textField?.stringValue = taxonName
            cell.textField?.drawsBackground = false
            return cell
        }
        if let characterPosition =  Int(tableColumn.identifier.rawValue), let taxonCharacterData = taxonData![taxonName] {
            if (characterPosition - 1)  < taxonCharacterData.count {
                let index =  taxonCharacterData.index(taxonCharacterData.startIndex, offsetBy: characterPosition-1)
                let characterString = String(taxonCharacterData[index])
                 setCellContent(cell, withCharacterString: characterString)
            } else {
                setCellContent(cell, withCharacterString: "")
            }

            return cell

        }

        return nil
    }
    
    

    func setCellContent(_ cell: NSTableCellView, withCharacterString characterString: String) {
        cell.textField?.stringValue = characterString
        cell.textField?.drawsBackground = true
        cell.textField?.backgroundColor = TaxonDataDNA.nucleotideColorCode(nucChar: characterString)
    }
    
    func addMatrixDataColumnsToTableView(){
        
        for column in tableView.tableColumns {
            tableView.removeTableColumn(column)
        }
        for columnDictionary in tableViewColumnsArray {
            let column: NSTableColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: columnDictionary.identifier))
            column.headerCell.title = columnDictionary.title
            column.width = CGFloat(self.columnDefaultWidth)
            column.minWidth = CGFloat(columnDictionary.minWidth)
            column.maxWidth = CGFloat(columnDictionary.maxWidth)
            tableView.addTableColumn(column)
        }
        
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
    }
    
}


struct ColumnDictionary {
    
    var identifier: String
    var title: String
    var type: String
    var maxWidth: Float
    var minWidth: Float
    
    init(identifier: String, title: String, type: String, maxWidth: Float, minWidth: Float) {
        self.identifier = identifier
        self.title = title
        self.type = type
        self.maxWidth = maxWidth
        self.minWidth = minWidth
    }
}



