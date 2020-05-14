//
//  Constants.swift
//  macguiTests
//
//  Created by Svetlana Krasikova on 11/18/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Foundation

class TestDataConstants {
    
    
//    MARK: -- Data Matrix
    
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
    
//    MARK: -- Model Tool
    
    static let exponentialDistribution = """
            {
                "name": "Exponential Distribution",
                "domain": "RealPos",
                "descriptiveString": "The exponential distribution models the waiting time between events that occur at a constant rate, \u{039B}.",
                "parameters": [{"name": "\u{039B}", "type": "RealPos", "descriptiveString": "The rate parameter of the process"}]

            }
"""
static let normalDistribution =  """
            {
                "name": "Normal Distribution",
                "domain": "Real",
                "descriptiveString": "The normal distribution, also known as the Gaussian or Bell-shaped distribution, is used to model many biological phenomena, partly because of the Central Limit Theorem.",
                "parameters": [{"name": "\u{03BC}", "type": "Real", "descriptiveString": "The mean of the normal distribution"},
                                {"name": "\u{03C3}", "type": "RealPos", "descriptiveString": "The standard deviation of the distribution."}
                                ]

            }
"""
 
    static let gammaDistribution =  """
                {
                    "name": "Gamma Distribution",
                    "domain": "RealPos",
                    "descriptiveString": "The gamma distribution represents a generalization of the exponential, with the rate being the scale parameter and the number of summed sojourn times being the scale.",
                    "parameters": [{"name": "\u{03B1}", "type": "RealPos", "descriptiveString": "The shape parameter of the gamma distribution."},
                                    {"name": "\u{03D0}", "type": "RealPos", "descriptiveString": "The scale parameter of the gamma distribution."}
                                    ]

                }
    """
    
    
    static let poissonDistribution =  """
                {
                    "name": "Poisson Distribution",
                    "domain": "Natural",
                    "descriptiveString": "The Poisson distribution models the number of events that occur in some time interval when the rate at which the events occur is constant.",
                    "parameters": [{"name": "\u{039B}", "type": "RealPos", "descriptiveString": "The rate parameter of the process."}]

                }
    """
}
