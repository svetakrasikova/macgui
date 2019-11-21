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
    
    var taxonData: [String:[Character]]? {
        guard let matrix = self.matrix else { return nil }
        var taxonData = [String:[Character]]()
        for taxonIndex in 0..<matrix.numTaxa {
            let characterDataString = matrix.taxonData[taxonIndex].characterDataString()
            taxonData[matrix.taxonNames[taxonIndex]] = Array(characterDataString)
        }
        return taxonData
    }
    
    var tableViewColumnsArray: Array<ColumnDictionary> = []
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
        guard let numberOfRows = taxonData?.keys.count else {
            return 0
        }
        return numberOfRows
    }
    
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let taxonData = self.taxonData, let tableColumn = tableColumn  else { return nil }
        
        let taxaNames: [String] =  Array<String>(taxonData.keys)
        
        if tableColumn.title == "Taxon Name" {
            return taxaNames[row]
        }

        if let taxonCharacterData: [Character] = taxonData[taxaNames[row]], let characterPosition =  Int(tableColumn.identifier.rawValue)  {
            return String(taxonCharacterData[characterPosition-1])

       }
        return nil
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


