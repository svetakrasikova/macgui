//
//  Label.swift
//  macgui
//
//  Created by Svetlana Krasikova on 3/22/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

enum Symbol {
    case doubleStruckCapitalN
    case doubleStruckCapitalR
    case empty
}

extension Symbol: RawRepresentable {
    
    typealias RawValue = String
    
    init?(rawValue: String) {
        switch rawValue {
        case "\u{2115}": self = .doubleStruckCapitalN
        case "\u{211D}": self = .doubleStruckCapitalR
        default:
            self = .empty
        }
    }
    
    var rawValue: String {
        switch self {
        case .doubleStruckCapitalN:
            return "\u{2115}"
        case .doubleStruckCapitalR:
            return "\u{211D}"
        case .empty:
            return ""
        }
    }
    
}
