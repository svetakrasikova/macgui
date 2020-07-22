//
//  MatrixViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/13/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class MatrixViewController: NSViewController {
    

    var taxaMatrix: NSMatrix?
    var dataMatrix: NSMatrix?
    
    

    @IBOutlet weak var splitView: NSSplitView!
    @IBOutlet weak var matrixView: NSView!
    @IBOutlet weak var matrixScrollView: NSScrollView!
    @IBOutlet weak var taxaNamesView: NSView!
    @IBOutlet weak var taxaNamesScrollView: NSScrollView!
    @IBOutlet weak var matrixViewerSplitView: NSSplitView!
    
    var dataMatrices: [DataMatrix]?
    var taxonData: [String:String]?
    var taxaNames: [String]?
    var isContinuous: Bool?
    var maxNumberCharacters: Int?
    var dataType: DataType?
    
    var numberRows: Int {
        guard let taxaNames = self.taxaNames else { return 0 }
        return taxaNames.count + 2
    }
   
    var taxaNamesWidth: CGFloat? {
        guard let taxaNames = self.taxaNames else {
            return nil
        }
        return String.lengthOfLongestString(taxaNames, fontSize: 12.0)
    }
    
    enum Appearance {
        static let cellWidth: CGFloat = 18.0
        static let cellHeight: CGFloat = 18.0
        static let headerBackgroundColor: NSColor = NSColor.darkGray
        static let headerTextColor: NSColor = NSColor.white
        static let namesBackgroundColor: NSColor = NSColor.white
        static let namesTextColor: NSColor = NSColor.black
    }
    
    
    override func viewDidLoad() {
        if let matrixScrollView = self.matrixScrollView as? SynchroScrollView, let taxaNamesScrollView = self.taxaNamesScrollView as? SynchroScrollView {
            matrixScrollView.setSynchronizedScrollView(view: taxaNamesScrollView)
            taxaNamesScrollView.setSynchronizedScrollView(view: matrixScrollView)
        }
    
       
    }
    
    
    func showSelectedMatrix(matrixIndex: Int) {
        
        if let matrixToShow = self.dataMatrices?[matrixIndex] {
            clearMatrixView()
            setDataFromSelectedMatrix(matrixToShow)
            setTaxaNamesView()
            setDataMatrixView()
        }
    }
    
    func clearMatrixView() {
        for subview in taxaNamesView.subviews {
            if subview.isKind(of: NSMatrix.self) {
                subview.removeFromSuperview()
            }
        }
        
        for subview in matrixView.subviews {
            if subview.isKind(of: NSMatrix.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    func setDataFromSelectedMatrix(_ matrix: DataMatrix){
        self.isContinuous = ( matrix.dataType == DataType.Continuous ? true : false )
        self.dataType = matrix.dataType
        self.taxaNames = matrix.getTaxaNames()
        var taxonData = [String:String]()
        let activeTaxonNames : [String] = matrix.getActiveTaxaNames()
        for n in activeTaxonNames {
            if let td = matrix.getTaxonData(name: n) {
                taxonData[n] = td.characterDataString()
            }
        }
        self.taxonData = taxonData
        self.maxNumberCharacters = matrix.numberOfCharactersToInt(numberOfCharacters: matrix.getNumCharacters())
    }
    
    func initializeTaxaMatrix(){
        
        if let taxaNames = taxaNames, let taxaNamesWidth = self.taxaNamesWidth {
            
            let size = NSSize(width: taxaNamesWidth, height: taxaNamesView.frame.size.height)
            let frameRect = NSRect(origin: taxaNamesView.frame.origin, size: size)
            let taxaMatrix = NSMatrix(frame: frameRect, mode: .listModeMatrix, cellClass: NSTextFieldCell.self, numberOfRows: numberRows, numberOfColumns: 1)
            taxaMatrix.cellSize = NSMakeSize(taxaNamesWidth, Appearance.cellHeight)
            
            setMatrixViewProperties(matrix: taxaMatrix)
            
            for index in 0..<taxaMatrix.cells.count {
                let cell: NSTextFieldCell = taxaMatrix.cell(atRow: index, column: 0)  as! NSTextFieldCell
                if index == 0 {
                    setMatrixCell(cell: cell, backgroundColor: Appearance.headerBackgroundColor, textColor: Appearance.headerTextColor, stringValue: "Taxon")
                } else if index ==  1 {
                    setMatrixCell(cell: cell, backgroundColor: Appearance.headerBackgroundColor, textColor: Appearance.headerTextColor, stringValue: "Name")
                } else {
                    setMatrixCell(cell: cell, backgroundColor: Appearance.namesBackgroundColor, textColor: Appearance.namesTextColor, stringValue: taxaNames[index-2])
                }
            }
            
            self.taxaMatrix = taxaMatrix
        }
    }
    
    func lengthOfLongestName(taxaNames: [String]) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12.0)
        ]
        var longestName: CGFloat = 0.0
        for name in taxaNames {
            let attributedString = NSAttributedString(string: name, attributes: attributes)
            let nameLength = attributedString.size().width
            if longestName < nameLength {
                longestName = nameLength
            }
        }
        longestName += 12
        return longestName
        
    }
    
    
    func setMatrixCell(cell: NSTextFieldCell, backgroundColor: NSColor, textColor: NSColor, stringValue: String) {
        cell.tag = 1
        cell.isEditable = false
        cell.isSelectable = false
        cell.drawsBackground = true
        cell.alignment = .left
        cell.backgroundColor = backgroundColor
        cell.textColor = textColor
        cell.stringValue = stringValue
    }
    
    func setTaxaNamesView(){
        
        initializeTaxaMatrix()
        
        guard let taxaMatrix = self.taxaMatrix else { return }
        taxaNamesView.addSubview(taxaMatrix)
        taxaMatrix.leadingAnchor.constraint(equalTo: taxaNamesView.leadingAnchor).isActive = true
        taxaMatrix.topAnchor.constraint(equalTo: taxaNamesView.topAnchor).isActive = true
        taxaMatrix.trailingAnchor.constraint(equalTo: taxaNamesView.trailingAnchor).isActive = true
       
        if let preferredWidth = taxaNamesWidth {
            splitView.setPosition(preferredWidth, ofDividerAt: 0)
        }
    }
    
    func setMatrixViewProperties(matrix: NSMatrix) {
        matrix.translatesAutoresizingMaskIntoConstraints = false
        matrix.wantsLayer = true
        matrix.layer?.backgroundColor = NSColor.white.cgColor
        matrix.alignment = .center
        matrix.allowsEmptySelection = true
        matrix.intercellSpacing = NSMakeSize(0.0, 0.0)
        matrix.autorecalculatesCellSize = true
        matrix.autosizesCells = true
    }
    
    
    func initializeDataMatrix(){
        
        if let maxNumberCharacters = self.maxNumberCharacters, let taxonData = self.taxonData, let taxaNames = self.taxaNames {
            
            let numberColumns = maxNumberCharacters
            
            guard let isContinuous = self.isContinuous else { return }
            
            let cellWidth =  ( isContinuous ? Appearance.cellWidth * 10 : Appearance.cellWidth )
            
            let frameRect = NSRect(x: 0.0, y: 0.0, width: cellWidth * CGFloat(numberColumns), height: Appearance.cellHeight * CGFloat(numberRows))
            let dataMatrix = NSMatrix(frame: frameRect, mode: .listModeMatrix, cellClass: NSTextFieldCell.self, numberOfRows: numberRows, numberOfColumns: numberColumns)
            
            dataMatrix.cellSize = NSSize(width: cellWidth, height: Appearance.cellHeight)
            setMatrixViewProperties(matrix: dataMatrix)
            
            var nextSiteMarker: Int = 10
            var nextSiteMarkerString = NSString(string: "\(nextSiteMarker)")
            
            for i in 0..<numberRows {
                var nc = 0
                if i == 0 || i == 1 {
                    nc = numberColumns
                } else {
                    nc = taxonData[taxaNames[i-2]]?.count ?? 0
                    
                }
                
                for j in 0..<nc {
                    
                    var stringValue = ""
                    let cell: NSTextFieldCell = dataMatrix.cells[(i*numberColumns)+j] as! NSTextFieldCell
                    
                    switch i {
                  
                    case 0:
                        
                        var testVal = (j+1) % 10;
                        if (testVal == 0) {
                            testVal = 10;
                        }
                        if j == 0 {
                            stringValue = "1"
                        } else if  10 - testVal < nextSiteMarkerString.length {
                            
                            if  (j+1) <= (nc - nc % 10) {
                                let char = nextSiteMarkerString.character(at: nextSiteMarkerString.length-1-(10-testVal))
                                let character = Character(UnicodeScalar(char) ?? "?")
                                stringValue = String(character)
                            }
                            
                            if (j+1) % 10 == 0 {
                                nextSiteMarker += 10
                                nextSiteMarkerString = NSString(string: "\(nextSiteMarker)")
                            }
    
                        }
                        setMatrixCell(cell: cell, backgroundColor: Appearance.headerBackgroundColor, textColor: Appearance.headerTextColor, stringValue: stringValue)
                        
                    case 1:
                        
                        if isContinuous {
                            stringValue = "|"
                        } else {
                            if  j == 0 || (j+1) % 10 == 0 {
                                stringValue = "|"
                            } else {
                                stringValue = "."
                            }
                        }
                        setMatrixCell(cell: cell, backgroundColor: Appearance.headerBackgroundColor, textColor: Appearance.headerTextColor, stringValue: stringValue)
                        
                    default:
                        
                        let char = NSString(string: taxonData[taxaNames[i-2]]!).character(at: j)
                        let character = Character(UnicodeScalar(char) ?? "?")
                        if isContinuous {
                            stringValue = String(format: "%2.4f", String(character))
                            setMatrixCell(cell: cell, backgroundColor: NSColor.gray, textColor: NSColor.black, stringValue: stringValue)
                        } else {
                            stringValue = String(character)
                            let backgroundColor = getColorForCharacter(character)
                            setMatrixCell(cell: cell, backgroundColor: backgroundColor, textColor: NSColor.black, stringValue: stringValue)

                        }
                    }
                }
                
                
                for j in nc..<numberColumns {
                    if i > 1 {
                        
                        let cell: NSTextFieldCell = dataMatrix.cells[(i*numberColumns)+j] as! NSTextFieldCell
                        setMatrixCell(cell: cell, backgroundColor: Appearance.headerBackgroundColor, textColor: Appearance.headerTextColor, stringValue: "")
                    }
                }
        
            }
            self.dataMatrix = dataMatrix
        }
    }
    
    func getColorForCharacter(_ char: Character) -> NSColor {
        switch self.dataType {
        case .DNA?:
            return TaxonDataDNA.nucleotideColorCode(nucChar: String(char))
        case .RNA?:
            return TaxonDataDNA.nucleotideColorCode(nucChar: String(char))
        case .Standard?:
            return TaxonDataStandard.characterColorCode(Char: String(char))
        case .Protein?:
            return TaxonDataProtein.aminoAcidColorCode(Char: String(char))
        default:
            return NSColor.white
        }
    }
    
    func setDataMatrixView(){
        
        initializeDataMatrix()
        
        guard let dataMatrix = self.dataMatrix else { return }
        let size = NSSize(width: dataMatrix.frame.size.width, height: matrixView.frame.size.height)
        matrixView.setFrameSize(size)
        matrixView.addSubview(dataMatrix)
        dataMatrix.topAnchor.constraint(equalTo: matrixView.topAnchor).isActive = true
        dataMatrix.leadingAnchor.constraint(equalTo: matrixView.leadingAnchor).isActive = true
        dataMatrix.trailingAnchor.constraint(equalTo: matrixView.trailingAnchor).isActive = true

    }
    
}





