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
    
    @IBOutlet weak var matrixView: NSView!
    @IBOutlet weak var taxaNamesView: NSView!
    
    var dataMatrices: [DataMatrix]?
    var taxonData: [String:String]?
    var taxaNames: [String]?
    var isContinuous: Bool?
    var numberRows: Int {
        guard let taxaNames = self.taxaNames else { return 0 }
        return taxaNames.count + 2
    }
    var maxNumberCharacters: Int?
    
    var taxaNamesWidth: CGFloat? {
        guard let taxaNames = self.taxaNames else {
            return nil
        }
        return lengthOfLongestName(taxaNames: taxaNames)
    }
    
    enum Appearance {
        static let cellWidth: CGFloat = 16.0
        static let cellHeight: CGFloat = 16.0
        static let headerBackgroundColor: NSColor = NSColor.darkGray
        static let headerTextColor: NSColor = NSColor.white
        static let namesBackgroundColor: NSColor = NSColor.white
        static let namesTextColor: NSColor = NSColor.black
    }
    
    
    
    func showSelectedMatrix(matrixIndex: Int) {
        if let matrixToShow = self.dataMatrices?[matrixIndex] {
            setDataFromSelectedMatrix(matrixToShow)
            setTaxaNamesView()
            setDataMatrixView()
        }
    }
    
    func setDataFromSelectedMatrix(_ matrix: DataMatrix){
        self.isContinuous = ( matrix.dataType == DataType.Continuous ? true : false )
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
        if let taxaNames = taxaNames {
            let taxaMatrix = NSMatrix(frame: NSZeroRect, mode: .listModeMatrix, cellClass: NSTextFieldCell.self, numberOfRows: numberRows, numberOfColumns: 1)
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
            let nameWidth = lengthOfLongestName(taxaNames: taxaNames)
            taxaMatrix.cellSize = NSMakeSize(nameWidth, Appearance.cellHeight)
            taxaMatrix.frame =  taxaNamesView.frame
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
        
        if let taxaNamesWidth = self.taxaNamesWidth {
            let size = NSSize(width: taxaNamesWidth, height: taxaNamesView.frame.size.height)
            taxaNamesView.setFrameSize(size)
        }
        
        guard let taxaMatrix = self.taxaMatrix else { return }
        taxaNamesView.addSubview(taxaMatrix)
        taxaMatrix.widthAnchor.constraint(equalToConstant: taxaNamesView.frame.width).isActive = true
        taxaMatrix.heightAnchor.constraint(equalToConstant: taxaNamesView.frame.height).isActive = true
        taxaMatrix.leadingAnchor.constraint(equalTo: taxaNamesView.leadingAnchor).isActive = true
        taxaMatrix.bottomAnchor.constraint(equalTo: taxaNamesView.bottomAnchor).isActive = true
        taxaMatrix.trailingAnchor.constraint(equalTo: taxaNamesView.trailingAnchor).isActive = true
        taxaMatrix.topAnchor.constraint(equalTo: taxaNamesView.topAnchor).isActive = true
    }
    
    func setMatrixViewProperties(matrix: NSMatrix) {
        matrix.translatesAutoresizingMaskIntoConstraints = false
        matrix.wantsLayer = true
        matrix.layer?.backgroundColor = NSColor.white.cgColor
        matrix.alignment = .center
        matrix.allowsEmptySelection = true
        matrix.intercellSpacing = NSMakeSize(0.0, 0.0)
    }
    
    
    func initializeDataMatrix(){
        
        if let maxNumberCharacters = self.maxNumberCharacters, let taxonData = self.taxonData, let taxaNames = self.taxaNames {
            
            let numberColumns = maxNumberCharacters
            
            guard let isContinuous = self.isContinuous else { return }
            
            let cellWidth =  ( isContinuous ? Appearance.cellWidth * 10 : Appearance.cellWidth )
            
            let frameRect = NSRect(x: 0.0, y: 0.0, width: cellWidth * CGFloat(numberColumns), height: Appearance.cellHeight * CGFloat(numberRows))
            let dataMatrix = NSMatrix(frame: frameRect, mode: .listModeMatrix, cellClass: NSTextFieldCell.self, numberOfRows: numberRows, numberOfColumns: numberColumns)
            
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
                                stringValue = String( nextSiteMarkerString.character(at: nextSiteMarkerString.length-1-10-testVal))
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
                        let character = NSString(string: taxonData[taxaNames[i-2]]!).character(at: j)
                        if isContinuous {
                            stringValue = String(format: "%2.4f", character)
                            setMatrixCell(cell: cell, backgroundColor: NSColor.gray, textColor: NSColor.black, stringValue: stringValue)
                        } else {
                            stringValue = String(character)

                        }
                    }
                }
        
            }
            
            
            //
            //                    {
            //                    // setting up discrete matrix
            //                    //char state = [dataMatrixCell getDiscreteState];
            //                    char state = [matrix stateWithRow:(i-2) andColumn:j];
            //
            //                    if ( [dataMatrixCell isGapState] == YES )
            //                        state = '-';
            //                    NSString* stateStr = [NSString localizedStringWithFormat:@"%c", state];
            //
            //                    NSDictionary* colorDict;
            //                    if ([dataMatrixCell dataType] == DNA || [dataMatrixCell dataType] == RNA)
            //                        colorDict = [self nucleotideColorsDict];
            //                    else if ([dataMatrixCell dataType] == AA)
            //                        colorDict = [self aminoColorsDict];
            //                    else if ([dataMatrixCell dataType] == STANDARD)
            //                        colorDict = [self standardColorsDict];
            //                    NSColor* textColor = [NSColor blackColor];
            //                    NSColor* bkgrndColor = [colorDict objectForKey:stateStr];
            //                    if ( [matrix isCharacterExcluded:j] == YES || [matrix isTaxonExcluded:(i-2)] == YES )
            //                        bkgrndColor = [NSColor grayColor];
            //                    bkgrndColor = [bkgrndColor colorWithAlphaComponent:0.5];
            //
            //
            //                    NSTextFieldCell* aCell = [allCells objectAtIndex:(i*nCols)+j];
            //                    [aCell setTag:1];
            //                    [aCell setEditable:NO];
            //                    [aCell setSelectable:NO];
            //                    [aCell setDrawsBackground:YES];
            //                    [aCell setBackgroundColor:bkgrndColor];
            //                    [aCell setTextColor:textColor];
            //                    [aCell setAlignment:NSCenterTextAlignment];
            //                    [aCell setStringValue:[NSString stringWithFormat:@"%c", state]];
            //                    }
            //                }
            //            }
        }
    }
    
    func setDataMatrixView(){
        
    }
    
    
    
    
    
    
    
    
}



