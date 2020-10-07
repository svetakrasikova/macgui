//
//  JsonCoreBridge.swift
//  macgui
//
//  Created by Svetlana Krasikova on 12/10/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

enum ReadDataError: Error {
    
    case fetchDataError(fileURL: URL)
    case readError
    case coreJsonError
    case dataDecodingError
    case taxonDataInitError

}


class JsonCoreBridge {
    
    enum CoreJsonKeys: String {
        case matrix = "CharacterDataMatrix"
        case taxa = "taxa"
        case filePath = "filePath"
        case fileName = "fileName"
        case dataType = "dataType"
        case deletedTaxa = "deletedTaxa"
        case stateLabels = "stateLabels"
        case data = "data"
        case DiscreteTaxonData = "DiscreteTaxonData"
        case Taxon = "Taxon"
        case taxonName = "name"
        case charData = "charData"
        
        
    }
    
    enum CoreJsonError: Error {
        case taxaError
        case matrixName
        case filePath
        case dataType
        case deletedTaxa
        case stateLabels
        case data
        case discreteTaxonData
        case taxonName
        case charData
        
    }
    
    var homologyEstablished: Bool = true
    var isCharacterDeleted: Bitvector = Bitvector()
    
    
    var jsonStringArray: [String]
    
    init(jsonArray: [String]){
        self.jsonStringArray = jsonArray
    }
    
    func encodeMatrixJsonStringArray() throws -> [Data] {
        var dataArray: [Data] = []
        for jsonString in jsonStringArray {
            do {
                let json = try JSONSerialization.jsonObject(with: Data(jsonString.utf8), options: .mutableContainers)
                guard let dictionary = json as? [String: Any], let nestedDictionary = dictionary[CoreJsonKeys.matrix.rawValue] as? [String: Any]
                    else {
                        throw ReadDataError.coreJsonError
                }
                let matrixJsonString = matrixJsonStringFromDictionary(nestedDictionary)
                dataArray.append(matrixJsonString.data(using: .utf8)!)
                
            } catch {
                throw ReadDataError.coreJsonError
            }
        }
        
        return dataArray
    }
    
    func encodeJsonStringArray() -> [Data] {
    
        var dataArray: [Data] = []
        for jsonString in jsonStringArray {
            dataArray.append(jsonString.data(using: .utf8)!)
        }
        return dataArray
    }
    
    func matrixJsonStringFromDictionary(_ dict: [String: Any]) -> String {
        var matrixJsonString: String = ""
        do {
            matrixJsonString +=  """
            {
            "numTaxa": \(try numOfTaxaFromDict(dict)),
            "taxonNames": \(try taxonNamesFromDict(dict)),
            "matrixName": "\(try matrixNameFromDict(dict))",
            "dataFileName": "\(try dataFileNameFromDict(dict))",
            "dataType": "\(try dataTypeFromDict(dict))",
            "deletedTaxa":\(try deletedTaxaFromDict(dict)),
            "stateLabels": "\(try stateLabelsFromDict(dict))",
            "taxonData": \(try encodeTaxonData(dict)),
            "homologyEstablished": \(homologyEstablished),
            "isCharacterDeleted": \(encodeIsCharacterDeleted()),
            }
            """
        } catch CoreJsonError.taxaError {
            print("The value of field 'taxa' in the core JSON data is corrupted.")
        } catch CoreJsonError.matrixName {
            print ("The value of field 'matrixName' in core JSON data is corrupted.")
        } catch CoreJsonError.filePath {
            print ("The value of field 'filePath' in core JSON data is corrupted.")
        } catch CoreJsonError.dataType {
            print ("The value of field 'dataType' in core JSON data is corrupted.")
        } catch CoreJsonError.deletedTaxa {
            print ("The value of field 'deletedTaxa' in core JSON data is corrupted.")
        } catch CoreJsonError.stateLabels {
            print ("The value of field 'stateLabels' in core JSON data is corrupted.")
        } catch CoreJsonError.data{
            print ("The value of field 'data' in core JSON data is corrupted.")
        } catch CoreJsonError.discreteTaxonData {
            print ("The value of field 'DiscreteTaxonData' in core JSON data is corrupted.")
        } catch CoreJsonError.taxonName {
            print ("The value of field 'name' in core JSON data is corrupted.")
        } catch CoreJsonError.charData {
            print ("The value of field 'charData' in core JSON data is corrupted.")
        } catch ReadDataError.taxonDataInitError {
            print ("Error trying to initialize a taxon data object from data.")
        } catch {
            print("Unexpected error: \(error).")
        }
        return matrixJsonString
    }

    func numOfTaxaFromDict(_ dict: [String: Any]) throws -> Int {
        guard let taxa = dict[CoreJsonKeys.taxa.rawValue] as? [String]
            else {
                throw CoreJsonError.taxaError
        }
        return taxa.count
    }
    
    func taxonNamesFromDict(_ dict: [String: Any]) throws -> [String] {
        guard let taxa = dict[CoreJsonKeys.taxa.rawValue] as? [String]
            else {
                throw CoreJsonError.taxaError
        }
        return taxa
    }
    
    func matrixNameFromDict(_ dict: [String: Any]) throws -> String {
        guard let matrixName = dict[CoreJsonKeys.fileName.rawValue]  as? String
            else {
                throw CoreJsonError.matrixName
        }
        return matrixName
    }
    
    func dataFileNameFromDict(_ dict: [String: Any]) throws -> String {
        guard var path = dict[CoreJsonKeys.filePath.rawValue] as? String
            else {
                throw CoreJsonError.filePath
        }
        path += "/\(try matrixNameFromDict(dict))"
        return path
    }
    
    func dataTypeFromDict(_ dict: [String: Any]) throws -> String {
        guard let dataType = dict[CoreJsonKeys.dataType.rawValue] as? String
            else {
                throw CoreJsonError.dataType
        }
        return dataType
    }
    
    func deletedTaxaFromDict(_ dict: [String: Any]) throws -> [String] {
        guard let deletedTaxa = dict[CoreJsonKeys.deletedTaxa.rawValue] as? [String]
            else {
                throw CoreJsonError.deletedTaxa
        }
        return deletedTaxa
    }
    
    func stateLabelsFromDict(_ dict: [String: Any]) throws -> String {
        guard let stateLabels = dict[CoreJsonKeys.stateLabels.rawValue] as? String
            else {
                throw CoreJsonError.stateLabels
        }
        return stateLabels
    }
    
    func encodeIsCharacterDeleted() -> String {
       return String(data: (try! JSONEncoder().encode(isCharacterDeleted)), encoding: .utf8)!
    }
    
    func encodeTaxonData(_ dict: [String: Any]) throws -> String {
        
        self.homologyEstablished = true
        var taxonDataDictString: String = "{"
        var numCharacters: Int = 0
        
        guard let data = dict[CoreJsonKeys.data.rawValue] as? [[String: Any]]
            else {
                throw CoreJsonError.data
        }
        guard data.count == (try! numOfTaxaFromDict(dict)) else {
            throw CoreJsonError.taxaError
        }
        
        if let dataType = DataType(rawValue: try! dataTypeFromDict(dict)) {

            for (index, taxonData) in data.enumerated() {
                guard let discreteTaxonData = taxonData[CoreJsonKeys.DiscreteTaxonData.rawValue] as? [String: Any], let taxon = discreteTaxonData[CoreJsonKeys.Taxon.rawValue] as? [String: Any]
                    else {
                        throw CoreJsonError.discreteTaxonData
                }
                guard let taxonName = taxon[CoreJsonKeys.taxonName.rawValue] as? String
                    else {
                        throw CoreJsonError.taxonName
                }
                guard let charData = discreteTaxonData[CoreJsonKeys.charData.rawValue] as? [String]
                    else {
                        throw CoreJsonError.charData
                }
                guard let taxonData = try initTaxonDataByType(dataType, taxonName: taxonName, charData: charData.joined()) else {
                    throw ReadDataError.taxonDataInitError
                }
                if taxonData.numCharacters != numCharacters && index > 0 {
                    self.homologyEstablished = false
                }
                
                numCharacters = taxonData.numCharacters
                
                if taxonData.numCharacters > isCharacterDeleted.size() {
                    let n : Int = taxonData.numCharacters - self.isCharacterDeleted.size()
                    for _ in 0..<n {
                        self.isCharacterDeleted += false
                    }
                } else {
                    for _ in 0..<taxonData.numCharacters {
                        self.isCharacterDeleted += false
                    }
                }
                
                let taxonDataJsonString: String = String(data: (try! JSONEncoder().encode(taxonData)), encoding: .utf8)!
                taxonDataDictString += "\"\(taxonName)\":\(taxonDataJsonString),"
            }
        }
        taxonDataDictString += "}"
        return taxonDataDictString
    }
    
    
    func initTaxonDataByType(_ dataType: DataType, taxonName: String, charData: String) throws -> TaxonData? {
        switch dataType {
        case .DNA:
            let taxonDataDNA = try TaxonDataDNA(taxonName: taxonName, nucleotideString: charData)
            return taxonDataDNA
        case .RNA:
            let taxonDataRNA = try TaxonDataRNA(taxonName: taxonName, nucleotideString: charData)
            return taxonDataRNA
            
        case .Protein:
            let taxonDataProtein = try TaxonDataProtein(taxonName: taxonName, aminoAcidString: charData)
            return taxonDataProtein
        default:
            print("Standard and Continuous taxon data types cannot be handled yet")
        }
        return nil
    }
    
    
}


