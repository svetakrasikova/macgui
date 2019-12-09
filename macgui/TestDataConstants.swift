//
//  Constants.swift
//  macguiTests
//
//  Created by Svetlana Krasikova on 11/18/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Foundation

class TestDataConstants {
    
    static  let emptyBitVectorJsonString: String = String(data: (try! JSONEncoder().encode(Bitvector())), encoding: .utf8)!
    
    static let  (A, T, G, C): (String, String, String, String) = ("A", "T", "G", "C")
    
    static let charData: String = [A,T,G,C,T,G,C,C].joined()

    
    static let taxonDataDNA = try! TaxonDataDNA(taxonName: "Sbay", nucleotideString: String(charData))
    static  let taxonDataDNAJsonString: String = String(data: (try! JSONEncoder().encode(taxonDataDNA)), encoding: .utf8)!
    
    static let matrixJson = """
 {
   "numTaxa": 1,
   "taxonNames": [
     "Sbay"
   ],
   "matrixName": "nYAL021C",
   "dataFileName": "/Users/svetakrasikova/Documents/Data/rawfas/nYAL021C",
   "dataType": "DNA",
   "homologyEstablished": true,
   "deletedTaxa": [
     
   ],
   "isCharacterDeleted": \(emptyBitVectorJsonString),
   "stateLabels": "",
   "taxonData": 
     {
       "Sbay": \(taxonDataDNAJsonString)
     }
 }
""".data(using: .utf8)!

}
