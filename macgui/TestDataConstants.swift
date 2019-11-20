//
//  Constants.swift
//  macguiTests
//
//  Created by Svetlana Krasikova on 11/18/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Foundation

class TestDataConstants {

    static let matrixJson = """
    {"homologyEstablished":true,"isTaxonDeleted":{"numInts":1,"mask":17870283321406128128,"vector":[0],"numElements":4},"taxonData":[{"dataType":"DNA","super":{"numInts":1,"mask":18446744073709543424,"vector":[9376784841553543168],"numElements":50},"numFlags":1,"numStates":4,"numCharacters":10,"taxonName":"Taxon 1"},{"dataType":"DNA","super":{"numInts":1,"mask":18446744073709543424,"vector":[4760450083537944576],"numElements":50},"numFlags":1,"numStates":4,"numCharacters":10,"taxonName":"Taxon 2"},{"dataType":"DNA","super":{"numInts":1,"mask":18446744073709543424,"vector":[2380225041768972288],"numElements":50},"numFlags":1,"numStates":4,"numCharacters":10,"taxonName":"Taxon 3"},{"dataType":"DNA","super":{"numInts":1,"mask":18446744073709543424,"vector":[1190112520884486144],"numElements":50},"numFlags":1,"numStates":4,"numCharacters":10,"taxonName":"Taxon 4"}],"dataFileName":"","dataType":"DNA","isCharacterDeleted":{"numInts":1,"mask":18437736874454810624,"vector":[0],"numElements":10},"taxonNames":["Taxon 1","Taxon 2","Taxon 3","Taxon 4"],"matrixName":"Test data matrix","numTaxa":4}

    """.data(using: .utf8)!
    
}
