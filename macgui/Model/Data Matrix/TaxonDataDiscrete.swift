//
//  TaxonDataDescrete.swift
//  data-model-sveta
//
//  Created by Svetlana Krasikova on 10/17/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Foundation

class TaxonDataDiscrete: TaxonData {
    
    // MARK: - Overloaded operators
    
    /// Override the `+=` operator allowing a character data string to be appended to the current sequence.
    static func +=(lhs: TaxonDataDiscrete, newVal: String) throws {
        
        // process the string, removing spaces and making certain the characters are uppercase
        var potentialCharacterStateString : String = newVal.uppercased()
        potentialCharacterStateString = potentialCharacterStateString.replacingOccurrences(of: " ", with: "")
        
        // check that the character state sequence is valid
        guard lhs.isValidCharacterStateString(potentialCharacterStateString:potentialCharacterStateString) == true else {
            print("Invalid character state string")
            throw TaxonDataError.concatenationError
        }
        
        // the string containing the character state sequence is good, so we can now add it
        lhs.numCharacters += potentialCharacterStateString.count
        for c in potentialCharacterStateString {
            lhs.addCharacter(characterState: c)
        }
        
    }
    
    /// Override the `+=` operator allowing concatenation of two taxon data.
    static func +=(lhs: TaxonDataDiscrete, rhs: TaxonDataDiscrete) throws {
        
        // check that the data are of the same type
        guard lhs.dataType == rhs.dataType else {
            print("Cannot concatenate taxon information of different types")
            throw TaxonDataError.concatenationError
        }
        
        guard lhs.taxonName == rhs.taxonName else {
            print("Cannot concatenate taxon information if the names differ (\(lhs.taxonName) and \(rhs.taxonName))")
            throw TaxonDataError.concatenationError
        }
        
        (lhs as Bitvector) += (rhs as Bitvector)
        lhs.numCharacters += rhs.numCharacters
        
    }
    
    static func + (lhs: TaxonDataDiscrete, rhs: TaxonDataDiscrete) throws -> Any?{
        
        // check that the data are of the same type
        guard lhs.dataType == rhs.dataType else {
            print("Cannot concatenate taxon information of different types")
            throw TaxonDataError.concatenationError
        }
        
        let result = lhs.copy() as! TaxonDataDiscrete
        (result as Bitvector) += (rhs as Bitvector)
        return result
        
    }
    
    
}
