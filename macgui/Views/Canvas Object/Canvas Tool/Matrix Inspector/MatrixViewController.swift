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
            let taxonCharacterData = taxonData![taxonName]
            let cell: NSTableCellView = tableView.makeView(withIdentifier: (NSUserInterfaceItemIdentifier(rawValue: "CharacterCell")), owner: self) as! NSTableCellView
            setCellContent(cell, withCharacterString: taxonCharacterData ?? "??", column: tableColumn)
            print("update cell, row \(row)")
//            cell.textField?.stringValue = taxonCharacterData ?? "#"
            
            return cell
        }
    }
    
    func autoSizeToFitWidth(column: NSTableColumn, string: NSAttributedString) {
        let rectAutoWidth: NSRect = string.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 24), options: [])

        if ( column.minWidth < rectAutoWidth.size.width )
        {
            column.minWidth = rectAutoWidth.size.width
            column.width = rectAutoWidth.size.width
        }
    }

    func setCellContent(_ cell: NSTableCellView, withCharacterString characterString: String, column: NSTableColumn) {
        cell.textField?.allowsEditingTextAttributes = true
        let attributedCharacterString = createAttributedStringFromString(characterString)
        cell.textField?.attributedStringValue = attributedCharacterString
        autoSizeToFitWidth(column: column, string: attributedCharacterString)
        
    }
    
    func createAttributedStringFromString(_ string: String) -> NSMutableAttributedString {
        var stringWithSpacing = ""
        for character in string {
            stringWithSpacing += "\(character) "
        }
        
        let attributedString = NSMutableAttributedString(string: stringWithSpacing)
        for i in stride(from: 0, to: stringWithSpacing.count, by: 2){
            let index = stringWithSpacing.index(stringWithSpacing.startIndex, offsetBy: i)
            let character = stringWithSpacing[index]
            let color = TaxonDataDNA.nucleotideColorCode(nucChar: String(character))
            let characterAttributes: [NSAttributedString.Key : Any] = [.backgroundColor: color, .font: NSFont.userFixedPitchFont(ofSize: 12) as Any, .kern: 1]
            attributedString.addAttributes(characterAttributes, range: NSRange(location: i, length: 1) )
        }
        return attributedString
    }
    

}



