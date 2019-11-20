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

    var matrix: DataMatrix? {
        didSet{
            tableView.reloadData()
        }
    }
    
    var taxonData: [String:[Character]]? {
        guard let matrix = self.matrix else { return nil }
        var taxonData = [String:[Character]]()
        for taxonIndex in 0..<matrix.numTaxa {
            let characterDataString = matrix.taxonData[taxonIndex].characterDataString()
            taxonData[matrix.taxonNames[taxonIndex]] = Array(characterDataString)
        }
        return taxonData
    }
    
    func showSelectedMatrix(matrixToShow: DataMatrix) {
        self.matrix = matrixToShow
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
        if tableColumn.title == "Character Data" {
            // For now just show the array of characters
            let taxonCharacterData: [Character] = taxonData[taxaNames[row]]!
            return String(taxonCharacterData)
        }
        return nil
    }
    
    
    //MARK: - NSTableViewDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

