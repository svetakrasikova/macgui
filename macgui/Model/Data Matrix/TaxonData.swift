//
//  TaxonDataSveta.swift
//  datamatrix
//
//  Created by Svetlana Krasikova on 10/15/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Foundation

class TaxonData : Bitvector, NSCopying {
    
    // MARK: - NSCopying protocol
    
    func copy(with zone: NSZone? = nil) -> Any {
        return TaxonData(numCharacters: numCharacters, numStates: numStates, numFlags: numFlags, taxonName: taxonName)
    }
    
    // MARK: - Properties
    
    /// The number of characters for this taxon.
    var numCharacters: Int
    /// The number of character states for the characters.
    internal var numStates: Int
    /// The number of additional flags per character.
    internal var numFlags: Int
    /// The name of the taxon.
    var taxonName: String
    /// The type of data
    internal var dataType: DataType

    
    // MARK: - Type definitions
    
    private enum CodingKeys: String, CodingKey {
        
        case numCharacters
        case numStates
        case numFlags
        case taxonName
        case dataType
    }
    
    enum TaxonDataError: Error {
        
        case encodingError
        case decodingError
        case incorrectDataFormat
        case copyError
        case incorrectStateInformation
        case concatenationError
    }
    
    
    // MARK: - Initializers
    
    /// Initialize with the number of characters and states.
    init(numCharacters: Int = 0, numStates: Int, numFlags: Int, taxonName: String = "", dataType: DataType = .Unknown) {
        
        self.numCharacters = numCharacters
        self.numStates = numStates
        self.numFlags = numFlags
        self.taxonName = taxonName
        self.dataType = dataType
        super.init(numElements: numCharacters*(numStates+numFlags) )
    }
    
    /// Initialize from serialized data.
    required init(from decoder: Decoder) throws {
        
        print("TaxonData decoder")
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.numCharacters = try container.decode(Int.self,    forKey: .numCharacters)
            self.numStates     = try container.decode(Int.self,    forKey: .numStates)
            self.numFlags      = try container.decode(Int.self,    forKey: .numFlags)
            self.taxonName     = try container.decode(String.self, forKey: .taxonName)
            self.dataType      = try container.decode(DataType.self, forKey: .dataType)
            try super.init(from: container.superDecoder())
        }
        catch {
            throw TaxonDataError.decodingError
        }
    }
    
    // MARK: - Codable protocol
    
    /// Encode the object for serialization.
    override func encode(to encoder: Encoder) throws {
        
        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try super.encode(to:container.superEncoder())
            
            try container.encode(numCharacters, forKey: .numCharacters)
            try container.encode(numStates,     forKey: .numStates)
            try container.encode(numFlags,      forKey: .numFlags)
            try container.encode(taxonName,     forKey: .taxonName)
            try container.encode(dataType,      forKey: .dataType)
        }
        catch {
            throw TaxonDataError.encodingError
        }
    }
    
    // MARK: - String representation
    
    override var description: String {
        
        let str: String = taxonName + characterDataString() + "\" [\(numCharacters)]\n \(bitString())"
        return str
    }
    
    // MARK: - Slicing 
    subscript(index: Int) -> Character {
        
        get {
            if index > 0 && index < numCharacters {
                let c : Character = getCharacterState(index: index)
                return c
            }
            else {
                return " "
            }
        }
        
        set(newValue) {
            
        }
    }
    
    
    // MARK: - Characters
    
    func addCharacter(characterState: Character) {}
    
    func characterDataString() -> String {
        
        return ""
    }
    
    func getCharacterState(index: Int) -> Character {
        
        return " "
    }
    
    
    func isValidCharacterState(potentialCharacterState: Character) -> Bool {
        return false
    }
    
    /// Check if the sequence contained in the string represents a valid sequence
    func isValidCharacterStateString(potentialCharacterStateString: String) -> Bool {
        for c in potentialCharacterStateString {
            if isValidCharacterState(potentialCharacterState: c) == false {
                return false
            }
        }
        return true
    }
    
    func setCharacterState(characterIdx: Int, characterState: Character) {
    
    }
  
    /// Return whether the character is a gap, or not.
       func isGap(dataChar: Character) -> Bool {
       
           if dataChar == "-" {
               return true
           }
           return false
       }
    
   func isSameStateSpace(taxonData: TaxonData) -> Bool {
          return true
      }

}
