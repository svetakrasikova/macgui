//
//  TaxonDataContinuous.swift
//  data-model-sveta
//
//  Created by Svetlana Krasikova on 10/17/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Foundation

class TaxonDataContinuous: TaxonData {
    
    internal var variables : [Double]
    
    // MARK: -
    
    private enum CodingKeys: String, CodingKey {
        
        case variables
    }
    
    // MARK: - Initializers

      init() {
        self.variables = []
        super.init(numStates: 0, numFlags: 0)
      }

      init(name: String, characterDataVector: [Double]) throws {

          self.variables = []
          for x in characterDataVector {
              self.variables.append(x)
          }
          super.init(numStates: 0, numFlags: 0, taxonName: name)
            self.numCharacters = self.variables.count
      }
      
      required init(from decoder: Decoder) throws {
      
          do {
              let container = try decoder.container(keyedBy: CodingKeys.self)
              self.variables = try container.decode([Double].self, forKey: .variables)
              try super.init(from: container.superDecoder())
          }
          catch {
              throw TaxonDataError.decodingError
          }
      }

      override func encode(to encoder: Encoder) throws {

          do {
              var container = encoder.container(keyedBy: CodingKeys.self)
              try container.encode(variables, forKey: .variables)
              try super.encode(to:container.superEncoder())
          }
          catch {
              throw TaxonDataError.encodingError
          }
      }
      
      override func copy(with zone: NSZone? = nil) -> Any {
      
          do {
              let copy = try TaxonDataContinuous(name: taxonName, characterDataVector: self.variables)
              return copy
          }
          catch {
              return TaxonDataContinuous()
          }
      }
    
    // MARK: - Operators
    
    
    /// Override the `+=` operator allowing concatenation of two taxon data.
    static func +=(lhs: TaxonDataContinuous, rhs: TaxonDataContinuous) throws {
        
        // check that they have the same name
        guard lhs.taxonName == rhs.taxonName else {
            print("Cannot concatenate taxon information if the names differ (\(lhs.taxonName) and \(rhs.taxonName))")
            throw TaxonDataError.concatenationError
        }
        
        for x in rhs.variables {
            lhs.variables.append(x)
        }
        lhs.numCharacters += rhs.numCharacters
    }
    
    static func +(firstTd: TaxonDataContinuous, secondTd: TaxonDataContinuous) throws -> Any?   {
        let result = firstTd.copy() as! TaxonData
        result += secondTd
        return result
        
    }
    

    static func +=(lhs: TaxonDataContinuous, newVal: Double) throws {
    
        lhs.variables.append(newVal)
        lhs.numCharacters += 1
    }
    
}
