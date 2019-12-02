//
//  DataTool.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/25/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class DataTool: Connectable {
<<<<<<< HEAD:macgui/Model/Tools/Connectables/DataTool.swift

    enum DataToolError: Error {
        
        case readError
        case jsonError
    }

    var dataMatrices: [DataMatrix] {
        get {
            return self.analysis.dataMatrices
        }
        set {
            self.analysis.dataMatrices = newValue
=======
    
    var dataMatrices: [DataMatrix]  = [] {
        didSet {
            if dataMatrices.isEmpty {
                NotificationCenter.default.post(name: .didUpdateDataMatrices, object: nil, userInfo: ["isEmpty" : true])
            } else {
                NotificationCenter.default.post(name: .didUpdateDataMatrices, object: nil, userInfo: ["isEmpty" : false])
            }
>>>>>>> b0ae5d47b3ff1f99352eae5028c07d58167b9b2d:macgui/Views/Canvas Object/Canvas Tool/Tool Objects/Connectable Tools/DataTool.swift
        }
    }
    
  override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
    super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addMatrix(jsonDictionary: [String: Any]) throws {
        
        // make a new data matrix
        let newDataMatrix : DataMatrix = DataMatrix()
        
        // 1. get the data type
        if let dt = jsonDictionary["dataType"] as? String {
            if dt == "DNA" {
                newDataMatrix.dataType = DataType.DNA
            }
            else if dt == "RNA" {
                newDataMatrix.dataType = DataType.RNA
            }
            else if dt == "Protein" {
                newDataMatrix.dataType = DataType.Protein
            }
            else if dt == "Standard" {
                newDataMatrix.dataType = DataType.Standard
            }
            else if dt == "Continuous" {
                newDataMatrix.dataType = DataType.Continuous
            }
            // others to consider and implement, such as Codon and PoMo
        }
        else {
            print("Could not find data type of the matrix")
            throw DataToolError.jsonError
        }

        // 2. get the path name
        if let pn = jsonDictionary["filePath"] as? String {
            newDataMatrix.dataFileName = pn
        }
        else {
            print("Could not find the file path for the matrix")
            throw DataToolError.jsonError
        }

        // 3. get the file name and append it to the path name
        if let fn = jsonDictionary["fileName"] as? String {
            newDataMatrix.dataFileName += "/" + fn
            newDataMatrix.matrixName = fn
        }
        else {
            print("Could not find the file name for the matrix")
            throw DataToolError.jsonError
        }

        // 4. get the state labels
        if let fn = jsonDictionary["stateLabels"] as? String {
            newDataMatrix.stateLabels = fn
        }
        else {
            print("Could not find the state labels for the matrix")
            throw DataToolError.jsonError
        }

        // 5. get the taxon data
        if let taxonData = jsonDictionary["data"] as? [[String: Any]] {
            for elem in taxonData {
                if let tdDict = elem["DiscreteTaxonData"] as? [String: Any] {
                
                    if newDataMatrix.dataType == DataType.DNA {
                        do {
                            let newTaxonData : TaxonDataDNA = try TaxonDataDNA(jsonDictionary:tdDict)
                            try newDataMatrix.addTaxonData(taxonData: newTaxonData)
                        }
                        catch {
                            print("Problem adding RNA taxon data")
                            throw DataToolError.jsonError
                        }
                    }
                    else if newDataMatrix.dataType == DataType.RNA {
                        do {
                            let newTaxonData : TaxonDataRNA = try TaxonDataRNA(jsonDictionary:tdDict)
                            try newDataMatrix.addTaxonData(taxonData: newTaxonData)
                        }
                        catch {
                            print("Problem adding RNA taxon data")
                            throw DataToolError.jsonError
                        }
                    }
                    else if newDataMatrix.dataType == DataType.Protein {
                        do {
                            let newTaxonData : TaxonDataProtein = try TaxonDataProtein(jsonDictionary:tdDict)
                            try newDataMatrix.addTaxonData(taxonData: newTaxonData)
                        }
                        catch {
                            print("Problem adding protein taxon data")
                            throw DataToolError.jsonError
                        }
                    }
                    else if newDataMatrix.dataType == DataType.Standard {
                        do {
                            let newTaxonData : TaxonDataStandard = try TaxonDataStandard(jsonDictionary:tdDict, stateLabels: stateLabels)
                            try newDataMatrix.addTaxonData(taxonData: newTaxonData)
                        }
                        catch {
                            print("Problem adding standard taxon data")
                            throw DataToolError.jsonError
                        }
                    }
                    else if newDataMatrix.dataType == DataType.Continuous {
                    
                    }
                }
                else {
                    print("Could not find the taxon list for the matrix")
                    throw DataToolError.jsonError
                }
            }
        }
        else {
            print("Could not find the taxon data for the matrix")
            throw DataToolError.jsonError
        }

        // 6. get the list of taxa
        if let tlist = jsonDictionary["taxa"] as? [String] {

            if tlist.count != newDataMatrix.numTaxa {
                print("Mismatch between the number of taxon data and the number of taxa")
                throw DataToolError.jsonError
            }
            
            var allTaxaFound : Bool = true
            for n in tlist {
                if newDataMatrix.isTaxonPresent(name: n) == false {
                    print("Could not find taxon \(n)")
                    allTaxaFound = false
                }
            }
            if allTaxaFound == false {
                print("Could not find all taxa that were expected to be in the matrix")
                throw DataToolError.jsonError
            }
            newDataMatrix.taxonNames = tlist
        }
        else {
            print("Could not find the taxon list for the matrix")
            throw DataToolError.jsonError
        }

    print(newDataMatrix)
    }
}
