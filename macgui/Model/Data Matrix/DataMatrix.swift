//
//  DataMatrix.swift
//  data-model-sveta
//
//  Created by Svetlana Krasikova on 10/18/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Foundation


enum DataType: String, Codable {
    
    case DNA = "DNA"
    case RNA = "RNA"
    case Protein = "Protein"
    case Standard = "Standard"
    case Continuous = "Continuous"
    case Unknown = "Unknown"
}


class DataMatrix : CustomStringConvertible, Codable {
    
    /// The number of taxa.
    var numTaxa : Int
    /// An array containing the taxon names.
    var taxonNames : [String]
    /// An array containing the taxon data.
    var taxonData : [TaxonData]
    /// A name for the character data matrix.
    var matrixName : String
    /// The file name from which the data originated.
    var dataFileName : String
    /// Is the homology of the character data established.
    var homologyEstablished : Bool
    /// A vector of bits indicating whether the taxon is deleted.
    var isTaxonDeleted = Bitvector()
    /// A vector of bits indicating whether the character is deleted.
    var isCharacterDeleted = Bitvector()
    /// The type of data contained by the matrix.
    var dataType : DataType = DataType.Unknown
    
    // MARK: - Codable  protocol
    
    private enum CodingKeys: String, CodingKey {
        
        case numTaxa
        case taxonNames
        case taxonData
        case matrixName
        case dataFileName
        case homologyEstablished
        case isTaxonDeleted
        case isCharacterDeleted
        case dataType
    }
    
    enum DataMatrixError: Error {
        
        case incompatibleDataTypes
        case encodingError
        case decodingError
        case writeError
        case concatenationError
    }
    
    // MARK: - Intializers
    
    /// Initialize an empty character data matrix.
    init() {
        
        self.numTaxa = 0
        self.taxonNames = []
        self.taxonData = []
        self.matrixName = ""
        self.dataFileName = ""
        self.homologyEstablished = true
    }
    
    /// Initialzie only the name of the character data matrix.
    init(name: String) {
        
        self.numTaxa = 0
        self.taxonNames = []
        self.taxonData = []
        self.matrixName = name
        self.dataFileName = ""
        self.homologyEstablished = true
    }
    
    /// Initialize from serialized data.
    required init(from decoder: Decoder) throws {
        
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.numTaxa             = try values.decode(Int.self,         forKey: .numTaxa)
            self.taxonNames          = try values.decode([String].self,    forKey: .taxonNames)
            self.matrixName          = try values.decode(String.self,      forKey: .matrixName)
            self.dataFileName        = try values.decode(String.self,      forKey: .dataFileName)
            self.homologyEstablished = try values.decode(Bool.self,        forKey: .homologyEstablished)
            self.isTaxonDeleted      = try values.decode(Bitvector.self,   forKey: .isTaxonDeleted)
            self.isCharacterDeleted  = try values.decode(Bitvector.self,   forKey: .isCharacterDeleted)
            self.dataType            = try values.decode(DataType.self,    forKey: .dataType)
            
            print(self.dataType)
            if self.dataType == .DNA {
                self.taxonData = try values.decode([TaxonDataDNA].self, forKey: .taxonData)
            }
            else if self.dataType == .RNA {
                self.taxonData = try values.decode([TaxonDataRNA].self, forKey: .taxonData)
            }
            else if self.dataType == .Protein {
                self.taxonData = try values.decode([TaxonDataRNA].self, forKey: .taxonData)
            }
            else {
                throw DataMatrixError.decodingError
            }
        }
        catch {
            throw DataMatrixError.decodingError
        }
    }
    
    /// Encode the object for serialization.
    func encode(to encoder: Encoder) throws {
        
        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(numTaxa,             forKey: .numTaxa)
            try container.encode(taxonNames,          forKey: .taxonNames)
            try container.encode(taxonData,           forKey: .taxonData)
            try container.encode(matrixName,          forKey: .matrixName)
            try container.encode(dataFileName,        forKey: .dataFileName)
            try container.encode(homologyEstablished, forKey: .homologyEstablished)
            try container.encode(isTaxonDeleted,      forKey: .isTaxonDeleted)
            try container.encode(isCharacterDeleted,  forKey: .isCharacterDeleted)
            try container.encode(dataType,            forKey: .dataType)
        }
        catch {
            throw DataMatrixError.encodingError
        }
    }
    
    /// Allow manipulation of the matrix through the subscript operator, e.g. `M[i,j]`
    subscript(rowIdx: Int, columnIdx: Int) -> Character {
        
        get {
            if validIndex(rowIdx: rowIdx, columnIdx: columnIdx) {
                let td = taxonData[rowIdx]
                return td[columnIdx]
            }
            else {
                return " "
            }
        }
        
        set(newValue) {
            if validIndex(rowIdx: rowIdx, columnIdx: columnIdx) {
                let td = taxonData[rowIdx]
                if td.isValidCharacterState(potentialCharacterState: newValue) {
                    td.setCharacterState(characterIdx: columnIdx, characterState: newValue)
                }
                else {
                    print("Invalid character state \(newValue)")
                }
            }
        }
    }
    
    // MARK: - Operators
    
    
    // concatenate matrices
    static func +=(lhs: DataMatrix, rhs: DataMatrix) throws {
        
        // check to see if it's OK to concatenate the two matrices
        if lhs.homologyEstablished == false || lhs.dataType != rhs.dataType {
            print("Concatenation failure because left- and right-hand sides are of incompatible types")
            throw DataMatrixError.concatenationError
        }
        
        // number of characters
        let (_, ncL) = lhs.getNumCharacters()
        let (_, ncR) = lhs.getNumCharacters()
        
        // concatenate to all taxon data found in lhs
        for tdL in lhs.taxonData {
            let nameL : String = tdL.taxonName
            let tdR = rhs.getTaxonData(name: nameL)
            if tdR == nil {
                var missingStr : String = ""
                for _ in 0..<ncR {
                    missingStr += "?"
                }
                do {
                    if tdL.dataType != .Continuous {
                        try (tdL as! TaxonDataDiscrete) += missingStr
                    }
                }
                catch {
                    print("Concatenation error for taxon \(nameL)")
                    throw DataMatrixError.concatenationError
                }
            }
            else {
                do {
                    if tdL.dataType != .Continuous {
                        try (tdL as! TaxonDataDiscrete) += (tdR as! TaxonDataDiscrete)
                    }
                    else {
                        try (tdL as! TaxonDataContinuous) += (tdR as! TaxonDataContinuous)
                    }
                }
                catch {
                    print("Concatenation failure for taxon \(nameL)")
                    throw DataMatrixError.concatenationError
                }
            }
        }
        
        // concatenate for all taxa unique to rhs
        for tdR in rhs.taxonData {
            let nameR : String = tdR.taxonName
            let tdL = lhs.getTaxonData(name: nameR)
            if tdL == nil {
                var missingStr : String = ""
                for _ in 0..<ncL {
                    missingStr += "?"
                }
                if tdR.dataType != .Continuous {
                    switch rhs.dataType {
                    case DataType.DNA:
                        do {
                            let newTd = try TaxonDataDNA(taxonName: nameR, nucleotideString: missingStr)
                            try newTd += (tdR as! TaxonDataDiscrete)
                            try lhs.addTaxonData(taxonData: newTd)
                        }
                        catch {
                            print("Concatenation failure for taxon \(nameR)")
                            throw DataMatrixError.concatenationError
                        }
                        
                    case DataType.RNA:
                        do {
                            let newTd = try TaxonDataRNA(taxonName: nameR, nucleotideString: missingStr)
                            try newTd += (tdR as! TaxonDataDiscrete)
                            try lhs.addTaxonData(taxonData: newTd)
                        }
                        catch {
                            print("Concatenation failure for taxon \(nameR)")
                            throw DataMatrixError.concatenationError
                        }
                        
                    case DataType.Protein:
                        do {
                            let newTd = try TaxonDataProtein(taxonName: nameR, aminoAcidString: missingStr)
                            try newTd += (tdR as! TaxonDataDiscrete)
                            try lhs.addTaxonData(taxonData: newTd)
                        }
                        catch {
                            print("Concatenation failure for taxon \(nameR)")
                            throw DataMatrixError.concatenationError
                        }
                        
                    case DataType.Standard:
                        do {
                            let castTdR = tdR as! TaxonDataStandard
                            let newTd = try TaxonDataStandard(taxonName: nameR, charcterDataString: missingStr, possibleStates: castTdR.possibleCharacterStates, missingCharacter: castTdR.missingCharacter)
                            try newTd += (tdR as! TaxonDataDiscrete)
                            try lhs.addTaxonData(taxonData: newTd)
                        }
                        catch {
                            print("Concatenation failure for taxon \(nameR)")
                            throw DataMatrixError.concatenationError
                        }
                        
                    default:
                        print("Concatenation failure for taxon \(nameR)")
                        throw DataMatrixError.concatenationError
                    }
                }
                else {
                    do {
                        let missingVec : [Double] = Array(repeating: 0.0, count: ncL)
                        let newTd = try TaxonDataContinuous(name: nameR, characterDataVector: missingVec)
                        try newTd += (tdR as! TaxonDataContinuous)
                        try lhs.addTaxonData(taxonData: newTd)
                    }
                    catch {
                        print("Concatenation failure for taxon \(nameR)")
                        throw DataMatrixError.concatenationError
                    }
                }
            }
        }
        
    }
    
    
    // append taxon data
    func addTaxonData(taxonData:TaxonData) throws {
        
        // check that the new taxon data is compatible with any
        // existing taxon data
        if self.taxonData.count == 0 {
            self.dataType = taxonData.dataType
        }
        else {
            guard taxonData.dataType == self.dataType else {
                throw DataMatrixError.incompatibleDataTypes
            }
        }
        
        // check that the states are the same
        if self.taxonData.count > 0 {
            guard taxonData.isSameStateSpace(taxonData: self.taxonData[0]) == true else {
                throw DataMatrixError.incompatibleDataTypes
            }
        }
        
        // check the homology
        if self.taxonData.count > 0 {
            if self.taxonData[0].numCharacters != taxonData.numCharacters {
                homologyEstablished = false
            }
        }
        else {
            homologyEstablished = true
        }
        
        // potentially increase the size of the bitvector indicating whether a character is deleted
        if self.taxonData.count == 0 {
            for _ in 0..<taxonData.numCharacters {
                self.isCharacterDeleted += false
            }
        }
        else {
            if taxonData.numCharacters > self.isCharacterDeleted.size() {
                let n : Int = taxonData.numCharacters - self.isCharacterDeleted.size()
                for _ in 0..<n {
                    self.isCharacterDeleted += false
                }
            }
        }
        
        // add the information
        self.taxonData.append(taxonData)
        self.taxonNames.append(taxonData.taxonName)
        self.numTaxa += 1
        self.isTaxonDeleted += false
    }
    
    // return a string with the data type
    func getDataType() -> String {
        
        return dataType.rawValue
    }
    
    // sensibly print the object's information
    var description: String {
        
        let (ntR, nt) = getNumCharacters()
        
        var str: String = ""
        str += "DataMatrix: \(matrixName)\n"
        str += "   Data type = \(dataType)\n"
        str += "   Number of taxa = \(numTaxa)\n"
        str += "   Number of characters = \(numberOfCharactersToString(numberOfCharacters:(ntR, nt)))\n"
        str += "   Taxon names = \(taxonNames)\n"
        str += "   Homology established = \(homologyEstablished)\n"
        for i in 0..<numTaxa {
            str += "   \(paddedTaxonName(index: i, underscore: false))   \(taxonData[i].characterDataString())\n"
        }
        for i in 0..<numTaxa {
            str += "   \(paddedTaxonName(index: i, underscore: false))   \(taxonData[i].bitString())\n"
        }
        str += "   Deleted taxa: \(self.getDeletedTaxaNames())\n"
        str += "   Deleted characters: \(self.getDeletedCharacters())\n"
        
        return str
    }
    
    func numberOfCharactersToString(numberOfCharacters: (ClosedRange<Int>, Int)) -> String {
              var numberCharactersString: String = ""
              let (ntR, nt) = numberOfCharacters
              if ntR.min() != ntR.max() {
                  numberCharactersString += "\(ntR)"
              }
              else {
                  numberCharactersString += "\(nt)"
              }
              return numberCharactersString
          }
    
    // check to see if the index is valid
    func validIndex(rowIdx: Int, columnIdx: Int) -> Bool {
        
        if rowIdx < 0 || columnIdx < 0 {
            return false
        }
        
        if rowIdx >= self.taxonData.count {
            return false
        }
        else {
            if columnIdx >= self.taxonData[0].numCharacters {
                return false
            }
        }
        return true
    }
    
    // write the data matrix to a file in NEXUS format
    func writeNexusFile(pathName: String, fileName: String) throws {
        
        // check that the directory exists
        var isDirectory = ObjCBool(true)
        let dirExists : Bool = FileManager.default.fileExists(atPath: pathName, isDirectory: &isDirectory)
        guard dirExists == true else {
            print("The directory \"\(pathName)\" does not exist")
            throw DataMatrixError.writeError
        }
        
        // create the complete name and path and check to see if that exists
        var fileURL = URL(fileURLWithPath: pathName)
        fileURL.appendPathComponent(fileName)
        let fileExists = FileManager.default.fileExists(atPath: fileURL.path)
        if fileExists == true {
            print("Overwriting file \"\(fileURL.absoluteString)\"")
        }
        
        // get the number of characters
        let (ntR, nt) = getNumCharacters()
        if ntR.min() != ntR.max() {
            print("The sequence lengths must be the same")
            throw DataMatrixError.writeError
        }
        
        // write the information to the file
        var str : String = ""
        str = "#NEXUS\n\n"
        str += "begin data;\n"
        str += "   dimensions ntax=\(numTaxa) nchar=\(nt);\n"
        if dataType == DataType.Standard {
            let td = self.taxonData[0] as! TaxonDataStandard
            str += "   format datatype=\(getDataType()) symbols=\"\(td.possibleCharacterStates)\" missing=\(td.missingCharacter);\n"
        }
        else {
            str += "   format datatype=\(getDataType()) missing=? gap=-;\n"
        }
        str += "   matrix\n"
        for i in 0..<numTaxa {
            str += "   \(paddedTaxonName(index: i, underscore: true))   \(taxonData[i].characterDataString())\n"
        }
        str += "   ;\n"
        str += "end;\n\n"
        
        let data = NSData(data: str.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        do {
            try data.write(to: URL(fileURLWithPath: fileURL.path), options: .atomic)
        }
        catch {
            throw DataMatrixError.writeError
        }
        
    }
    
    // MARK: -
    
    // delete the taxon by index
    func deleteTaxon(taxonIdx: Int) {
        
        if taxonIdx >= 0 && taxonIdx < self.isTaxonDeleted.size() {
            if self.isTaxonDeleted[taxonIdx] == true {
                print("Taxon \(taxonNames[taxonIdx]) is already deleted")
            }
            else {
                self.isTaxonDeleted[taxonIdx] = true
            }
        }
    }
    
    // delete the taxon by name
    func deleteTaxon(taxonId: String) {
        
        let isTaxonHere = taxonNames.contains(taxonId)
        if isTaxonHere == true {
            var taxonIdx : Int = 0
            for i in 0..<taxonNames.count {
                if taxonNames[i] == taxonId {
                    taxonIdx = i
                    break
                }
            }
            deleteTaxon(taxonIdx: taxonIdx)
        }
        else {
            print("Taxon \"\(taxonId)\" is not found in the matrix")
        }
    }
    
    // delete all the taxa
    func deleteAllTaxa() {
        
        for i in 0..<self.isTaxonDeleted.size() {
            self.isTaxonDeleted[i] = true
        }
    }
    
    // get the list of included taxa
    func getActiveTaxaNames() -> [String] {
        
        var activeTaxa : [String] = []
        for i in 0..<numTaxa {
            if self.isTaxonDeleted[i] == false {
                activeTaxa.append(taxonNames[i])
            }
        }
        return activeTaxa
    }
    
    // get the list of deleted taxa
    func getDeletedTaxaNames() -> [String] {
        
        var deletedTaxa : [String] = []
        for i in 0..<numTaxa {
            if self.isTaxonDeleted[i] == true {
                deletedTaxa.append(taxonNames[i])
            }
        }
        return deletedTaxa
    }
    
    // get taxon data
    func getTaxonData(name: String) -> TaxonData? {
        
        for td in taxonData {
            let n : String = td.taxonName
            if n == name {
                return td
            }
        }
        return nil
    }
    
    // get all taxa, active and deleted
    func getTaxaNames() -> [String] {
        
        return taxonNames
    }
    
    // is the taxon deleted?
    func isTaxonDeleted(taxonIdx: Int) -> Bool {
        
        if taxonIdx >= 0 && taxonIdx < self.isTaxonDeleted.size() {
            return self.isTaxonDeleted[taxonIdx]
        }
        return false
    }
    
    // check for presence of taxon
    func isTaxonPresent(name: String) -> Bool {
        
        for n in taxonNames {
            if n == name {
                return true
            }
        }
        return false
    }
    
    // find the length of the longest taxon name
    func lengthOfLonestName() -> Int {
        
        var len : Int = 0
        for n in taxonNames {
            if n.count > len {
                len = n.count
            }
        }
        return len
    }
    
    // return the taxon name, padded with spaces
    func paddedTaxonName(index: Int, underscore: Bool) -> String {
        
        let maxNameLength : Int = lengthOfLonestName()
        var str : String = taxonNames[index]
        if underscore == true {
            str = str.replacingOccurrences(of: " ", with: "_")
        }
        for _ in 0..<maxNameLength-taxonNames[index].count {
            str += " "
        }
        return str
    }
    
    // restore all taxa
    func restoreAllTaxa() {
        
        for i in 0..<self.isTaxonDeleted.size() {
            self.isTaxonDeleted[i] = false
        }
    }
    
    // restore the taxon by index
    func restoreTaxon(taxonIdx: Int) {
        
        if taxonIdx >= 0 && taxonIdx < self.isTaxonDeleted.size() {
            if self.isTaxonDeleted[taxonIdx] == false {
                print("Taxon \(taxonNames[taxonIdx]) is already included")
            }
            else {
                self.isTaxonDeleted[taxonIdx] = false
            }
        }
    }
    
    // restore the taxon by name
    func restoreTaxon(taxonId: String) {
        
        let isTaxonHere = taxonNames.contains(taxonId)
        if isTaxonHere == true {
            var taxonIdx : Int = 0
            for i in 0..<taxonNames.count {
                if taxonNames[i] == taxonId {
                    taxonIdx = i
                    break
                }
            }
            restoreTaxon(taxonIdx: taxonIdx)
        }
        else {
            print("Taxon \"\(taxonId)\" is not found in the matrix")
        }
    }
    
    // MARK: -
    
    // delete a particular character by its index
    func deleteCharacter(characterIdx: Int) {
        
        if homologyEstablished == false {
            print("Character cannot be deleted for a matrix in which homology has not been established")
            return
        }
        
        if characterIdx >= 0 && characterIdx < self.isCharacterDeleted.size() {
            if self.isCharacterDeleted[characterIdx] == true {
                print("Character \(characterIdx) is already deleted")
            }
            else {
                self.isCharacterDeleted[characterIdx] = true
            }
        }
    }
    
    // get a list of the active (included) characters
    func getActiveCharacters() -> [Int] {
        
        var activeCharacters : [Int] = []
        if homologyEstablished == true {
            for i in 0..<self.isCharacterDeleted.size() {
                if self.isCharacterDeleted[i] == false {
                    activeCharacters.append(i)
                }
            }
        }
        return activeCharacters;
    }
    
    func getDeletedCharacters() -> [Int] {
        
        var deletedCharacters : [Int] = []
        if homologyEstablished == true {
            for i in 0..<self.isCharacterDeleted.size() {
                if self.isCharacterDeleted[i] == true {
                    deletedCharacters.append(i)
                }
            }
        }
        return deletedCharacters;
    }
    
    // get the number of characters
    func getNumCharacters() -> (ClosedRange<Int>, Int) {
        
        var r : ClosedRange<Int>
        if numTaxa > 0 {
            var minV : Int = taxonData[0].numCharacters
            var maxV : Int = taxonData[0].numCharacters
            for td in taxonData {
                let x : Int = td.numCharacters
                if x < minV {
                    minV = x
                }
                if x > maxV {
                    maxV = x
                }
            }
            r = minV...maxV
            return (r, minV)
        }
        else {
            let r : ClosedRange = 0...0
            return (r, 0)
        }
    }
    
    
    // restore all characters
    func restoreAllCharacters() {
        
        for i in 0..<self.isCharacterDeleted.size() {
            self.isCharacterDeleted[i] = false
        }
    }
    
    // restore a particular character by its index
    func restoreCharacter(characterIdx: Int) {
        
        if characterIdx >= 0 && characterIdx < self.isCharacterDeleted.size() {
            if self.isCharacterDeleted[characterIdx] == false {
                print("Character \(characterIdx) is already included")
            }
            else {
                self.isCharacterDeleted[characterIdx] = false
            }
        }
    }
    
}
