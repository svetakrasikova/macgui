//
//  TaxonDataRNA.swift
//  data-model-sveta
//
//  Created by Svetlana Krasikova on 10/17/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Foundation

class TaxonDataRNA: TaxonDataDNA {
    
    
    // MARK: Initializers
    
    /// Initialize from the taxon name and a string of nucleotides characters.
    override init(taxonName: String, nucleotideString: String) throws {
    
        do {
            try super.init(taxonName: taxonName, nucleotideString: nucleotideString)
            self.dataType = .RNA
            }
        catch {
            throw TaxonDataError.incorrectDataFormat
        }
    }

    // initialize from serialized data
    required init(from decoder: Decoder) throws {
    
        do {
        try super.init(from: decoder)
        }
        catch {
            throw TaxonDataError.decodingError
        }
    }

   // MARK: NSCopying Protocol
    
    override func copy(with zone: NSZone? = nil) -> Any {
       
           do {
               let copy = try TaxonDataRNA(taxonName: taxonName, nucleotideString: self.characterDataString())
               return copy
           }
           catch {
               return TaxonData(numStates: 4, numFlags: 1, taxonName: taxonName, dataType: .RNA)
           }
       }
    
    // MARK: Characters
    
       /// Decode a vector of four Bool variables, returning the nucleotide using the IUPAC standard.
       override func decodeNucleotideVector(nucVector: [Bool]) -> Character {
       
           let nuc: Character = super.decodeNucleotideVector(nucVector: nucVector)
           if nuc == "T" {
               return "U"
           }
           else {
               return nuc
           }
       }

       /// Return the IUPAC nucleotide character.
       override func encodeNucleotide(nucChar: Character) -> Int {
       
           var rnaChar: Character = nucChar
           if nucChar == "U" {
               rnaChar = "T"
           }
           let nucCode: Int = super.encodeNucleotide(nucChar: rnaChar)
           return nucCode
       }

       /// Check that the state is valid.
       override func isValidCharacterState(potentialCharacterState: Character) -> Bool {

           let validRnaCharacters = "ACGURYMKSWHBVDN?-"
           if validRnaCharacters.contains(potentialCharacterState) == false {
               return false
           }
           return true
       }
    
}
