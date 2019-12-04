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

    var matrix: DataMatrix?
   
    var taxonData: [(String, [Character])]? {
        guard let matrix = self.matrix else { return nil }
        var taxonData = [(String, [Character])]()
        let activeTaxonNames : [String] = matrix.getActiveTaxaNames()
        for n in activeTaxonNames {
            if let td = matrix.getTaxonData(name: n) {
                taxonData.append((n,Array(td.characterDataString())))
            }
        }
        return taxonData
    }

    
    var tableViewColumnsArray: [ColumnDictionary] = []
    let columnDefaultWidth:Float = 100.0

    func populateTableViewColumnsArray() {
        if tableViewColumnsArray.count > 0 {
            tableViewColumnsArray.removeAll()
        }
        self.tableViewColumnsArray.append(ColumnDictionary(identifier: "Taxon Name", title: "Taxon Name", type: "text", maxWidth: 80.0, minWidth: 100.0))
        if let matrix = self.matrix {
            let numberOfCharacters = matrix.numberOfCharactersToInt(numberOfCharacters: matrix.getNumCharacters())
            for index in 1..<(numberOfCharacters+1) {
                self.tableViewColumnsArray.append(ColumnDictionary(identifier: "\(index)", title: "\(index)", type: "text", maxWidth: 20.0, minWidth: 20.0))
            }
            
        }
    }
    
    func showSelectedMatrix(matrixToShow: DataMatrix) {
        self.matrix = matrixToShow
        populateTableViewColumnsArray()
        addMatrixDataColumnsToTableView()
        tableView.reloadData()
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
        guard let taxonData = self.taxonData, let tableColumn = tableColumn  else { return nil }

        let taxaNames: [String] =  taxonData.map {$0.0}
        let cell: NSTableCellView = tableView.makeView(withIdentifier: (NSUserInterfaceItemIdentifier(rawValue: "CharacterCell")), owner: self) as! NSTableCellView


        if tableColumn.title == "Taxon Name" {
            cell.textField?.stringValue = taxaNames[row]
            return cell
        }

        if let characterPosition =  Int(tableColumn.identifier.rawValue)  {
            let taxonCharacterData: [Character] = taxonData[row].1
            let characterString = String(taxonCharacterData[characterPosition-1])
            setCellContent(cell, withCharacterString: characterString)
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
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



