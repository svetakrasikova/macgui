//
//  TaxonDataProtein.swift
//  data-model-sveta
//
//  Created by Svetlana Krasikova on 10/17/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Foundation
import Cocoa

class TaxonDataProtein: TaxonDataDiscrete {

    // MARK: Initializers
    
    /// Default initializer.
    init() {
   
        super.init(numStates: 20, numFlags: 1, dataType: .Protein)
    }
   
   /// Initialize from the taxon name and a string of nucleotides characters.
   init(taxonName: String, aminoAcidString: String) throws {
   
        // initialize the object (the bitvector will be empty)
        super.init(numStates: 20, numFlags: 1, taxonName:taxonName, dataType: .Protein)
       
        // process the string, removing spaces and making certain the characters are uppercase
        var potentialAminoAcidString : String = aminoAcidString.uppercased()
        potentialAminoAcidString = potentialAminoAcidString.replacingOccurrences(of: " ", with: "")
       
        // check that the nucleotide sequence is valid
        guard isValidCharacterStateString(potentialCharacterStateString:potentialAminoAcidString) == true else {
            print("The amino acid string has invalid characters")
            throw TaxonDataError.incorrectDataFormat
        }
       
        // the string containing the amino acid sequence is good, so we can now initialize it
        numCharacters = potentialAminoAcidString.count
        var readingAmbiguousState : Bool = false
        var ambiguousStates : String = ""
        for c in potentialAminoAcidString {
            if c == "(" {
                readingAmbiguousState = true
                ambiguousStates = ""
            }
            else if c == ")" {
                readingAmbiguousState = false
                addCharacters(characterStates:ambiguousStates)
            }
            if readingAmbiguousState == false {
                addCharacter(characterState: c)
            }
        }
    }
    
    static func aminoAcidColorCode(Char: String) -> NSColor {
        switch Char {
        case "A":
            return Color.orange.rawValue
        case "R":
            return Color.lightgreen.rawValue
        case "N":
            return Color.lightblue.rawValue
        case "D":
            return Color.yellow.rawValue
        case "C":
            return Color.maroon.rawValue
        case "Q":
            return Color.cyan.rawValue
        case "E":
            return Color.azure.rawValue
        case "G":
            return Color.darkblue.rawValue
        case "H":
            return Color.fuchsia.rawValue
        case "I":
            return Color.darkgreen.rawValue
        case "L":
            return Color.darkmagenta.rawValue
        case "K":
            return Color.red.rawValue
        case "M":
            return Color.khaki.rawValue
        case "F":
            return Color.brown.rawValue
        case "P":
            return Color.beige.rawValue
        case "S":
            return Color.lightpink.rawValue
        case "T":
            return Color.olive.rawValue
        case "W":
            return Color.lightcyan.rawValue
        case "Y":
            return Color.silver.rawValue
        case "V":
            return Color.purple.rawValue
        case "B":
            return Color.violet.rawValue
        case "Z":
            return Color.darkorchid.rawValue
        case "X":
            return Color.darkorange.rawValue
        case "*":
            return Color.darksalmon.rawValue
        case "?":
            return Color.darkgrey.rawValue
        case "-":
            return Color.aqua.rawValue
        case ".":
            return Color.aqua.rawValue
        default:
            return Color.white.rawValue
        }
    }

    /// Initialize from serialized data.
    required init(from decoder: Decoder) throws {
        do {
            try super.init(from: decoder)
        }
        catch {
            throw TaxonDataError.decodingError
        }
    }
       
    /// Initialize from JSON dictionary.
    required convenience init(jsonDictionary: [String: Any]) throws {
    
        // get the taxon name
        var taxonName : String = ""
        if let taxonInfo = jsonDictionary["Taxon"] as? [String: Any] {
            taxonName = taxonInfo["name"] as! String
        }
        else {
            print("Could not read the taxon information for the taxon data")
            throw TaxonDataError.decodingError
        }

        // get the character data
        var aminoAcidString : String = ""
        if let charArray = jsonDictionary["charData"] as? [String] {
            for str in charArray {
                aminoAcidString += str
            }
        }
        else {
            print("Could not read the characters for the taxon data")
            throw TaxonDataError.decodingError
        }

        do {
            try self.init(taxonName: taxonName, aminoAcidString: aminoAcidString)
        }
        catch {
            print("Problem initializing protein coding data")
            throw TaxonDataError.decodingError
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: NSCopying Protocol
    
    override func copy(with zone: NSZone? = nil) -> Any {

        do {
            let copy = try TaxonDataProtein(taxonName: taxonName, aminoAcidString: self.characterDataString())
            return copy
        }
        catch {
            return TaxonDataProtein()
        }
    }
    
    // MARK: Characters

    override func addCharacter(characterState: Character) {

        let aaCode: Int = encodeAminoAcid(aaChar: characterState)
        var aas: [Bool] = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
        encodeAminoAcidVector(aaCode: aaCode, aaVector: &aas)
        let isGapChar: Bool = isGap(dataChar: characterState)
        for i in 0..<20 {
            self += aas[i]
        }
        self += isGapChar
    }
       
    func addCharacters(characterStates: String) {
    
        var aas: [Bool] = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
        var isGapChar: Bool = false
        for c in characterStates {
            let aaCode: Int = encodeAminoAcid(aaChar: c)
            encodeAminoAcidVector(aaCode: aaCode, aaVector: &aas)
            if isGap(dataChar: c) == true {
                isGapChar = true
            }
        }
        
        for i in 0..<20 {
            self += aas[i]
        }
        self += isGapChar
    }

    /// Return a String holding the amino acid sequence for this taxon
    override func characterDataString() -> String {

        var str: String = ""
        for i in 0..<numCharacters {
            let offset = i * 21
            let isGapChar: Bool = self[offset + 20]
            if isGapChar == true {
                str += "-"
            }
            else {
                var aas: [Bool] = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
                for j in 0..<20 {
                    aas[j] = self[offset+j]
                }
            str += decodeAminoAcidVector(aaVector:aas)
            }
        }
        return str
    }

    /// Decode a vector of 20 Bool variables, returning the amino acid using the IUPAC standard
    func decodeAminoAcidVector(aaVector: [Bool]) -> String {

        // count the number of on bits in the vector
        var numOn: Int = 0
        for i in 0..<20 {
            if aaVector[i] == true {
                numOn += 1
            }
        }
        
        // return the appropriate string
        if numOn == 0
            {
            print("Could not decode empty amino acid vector")
            return " "
            }
        else if numOn == 1 {
            if aaVector[0] == true {
                return "G"
            }
            else if aaVector[1] == true {
                return "A"
            }
            else if aaVector[2] == true {
                return "L"
            }
            else if aaVector[3] == true {
                return "M"
            }
            else if aaVector[4] == true {
                return "F"
            }
            else if aaVector[5] == true {
                return "W"
            }
            else if aaVector[6] == true {
                return "K"
            }
            else if aaVector[7] == true {
                return "Q"
            }
            else if aaVector[8] == true {
                return "E"
            }
            else if aaVector[9] == true {
                return "S"
            }
            else if aaVector[10] == true {
                return "P"
            }
            else if aaVector[11] == true {
                return "V"
            }
            else if aaVector[12] == true {
                return "I"
            }
            else if aaVector[13] == true {
                return "C"
            }
            else if aaVector[14] == true {
                return "Y"
            }
            else if aaVector[15] == true {
                return "H"
            }
            else if aaVector[16] == true {
                return "R"
            }
            else if aaVector[17] == true {
                return "N"
            }
            else if aaVector[18] == true {
                return "D"
            }
            else {
                return "T"
            }
        }
        else if numOn == 2 {
            if aaVector[17] == true  && aaVector[18] == true {
                return "B"
            }
            else if aaVector[2] == true  && aaVector[12] == true {
                return "J"
            }
            else if aaVector[7] == true  && aaVector[8] == true {
                return "Z"
            }
        }
        else if numOn == 20 {
            return "?"
        }
        
        // if we are here, then we have some special sort of ambiguity and return a properly-formatted string
        let aaString : [String] = ["G","A","L","M","F","W","K","Q","E","S","P","V","I","C","Y","H","R","N","D","T"]
        var str : String = "("
        for i in 0..<20 {
            if aaVector[i] == true {
                str += aaString[i]
            }
        }
        str += ")"

        return str
    }

    /// Return the  bit vector for the IUPAC nucleotide character
    func encodeAminoAcid(aaChar: Character) -> Int {

        switch aaChar {
            case "G":
                return 1
            case "A":
                return 2
            case "L":
                return 4
            case "M":
                return 8
            case "F":
                return 16
            case "W":
                return 32
            case "K":
                return 64
            case "Q":
                return 128
            case "E":
                return 256
            case "S":
                return 512
            case "P":
                return 1024
            case "V":
                return 2048
            case "I":
                return 4096
            case "C":
                return 8192
            case "Y":
                return 16384
            case "H":
                return 32768
            case "R":
                return 65536
            case "N":
                return 131072
            case "D":
                return 262144
            case "T":
                return 524288
            case "B":
                return 131072 + 262144
            case "J":
                return 4096 + 4
            case "Z":
                return 128 + 256
            case "?":
                return 1048575
            case "-":
                return 1048575
            case "X":
                return 1048575
            default:
                return 0
        }
    }

    /// Fill out an array of 20 Bools that represent the IUPAC amino acid code
    func encodeAminoAcidVector(aaCode: Int, aaVector: inout [Bool]) {

        switch aaCode {
            case 1:
                aaVector[0] = true
            case 2:
                aaVector[1] = true
            case 4:
                aaVector[2] = true
            case 8:
                aaVector[3] = true
            case 16:
                aaVector[4] = true
            case 32:
                aaVector[5] = true
            case 64:
                aaVector[6] = true
            case 128:
                aaVector[7] = true
            case 256:
                aaVector[8] = true
            case 512:
                aaVector[9] = true
            case 1024:
                aaVector[10] = true
            case 2048:
                aaVector[11] = true
            case 4096:
                aaVector[12] = true
            case 8192:
                aaVector[13] = true
            case 16384:
                aaVector[14] = true
            case 32768:
                aaVector[15] = true
            case 65536:
                aaVector[16] = true
            case 131072:
                aaVector[17] = true
            case 262144:
                aaVector[18] = true
            case 524288:
                aaVector[19] = true
            case (131072 + 262144):
                aaVector[17] = true
                aaVector[18] = true
            case (4096 + 4):
                aaVector[2] = true
                aaVector[12] = true
            case (128 + 256):
                aaVector[7] = true
                aaVector[8] = true
            case 1048575:
                for i in 0..<20 {
                    aaVector[i] = true
                }
            default:
                for i in 0..<20 {
                    aaVector[i] = false
                }
        }
    }

    /// Check that the state is valid
    override func isValidCharacterState(potentialCharacterState: Character) -> Bool {

        let validAaCharacters = "GALMFWKQESPVICYHRNDTX?-BJZ()"
        if validAaCharacters.contains(potentialCharacterState) == false {
            return false
        }
        return true
    }

    override func setCharacterState(characterIdx: Int, characterState: Character) {

        let aaCode: Int = encodeAminoAcid(aaChar:characterState)
        var aas: [Bool] = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
        encodeAminoAcidVector(aaCode: aaCode, aaVector: &aas)
        let isGapChar: Bool = isGap(dataChar:characterState)

        let offset : Int = characterIdx * 21
        for i in 0..<20 {
            self[offset + i] = aas[i]
        }
        self[offset + 20] = isGapChar
    }

}
