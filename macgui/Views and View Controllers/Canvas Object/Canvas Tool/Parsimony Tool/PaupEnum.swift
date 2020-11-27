//
//  PaupError.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/10/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

enum PaupTablessViewItems: String {
    case PaupSearch
    case PaupCriterion
    case Overview
}

enum SummaryType: Int {
    
    case heuristicSearch
    case branchAndBountSearch
    case exhaustiveSearch
    case data
    case likelihood
    case parsimony
    case distance
}


enum PaupSearchTabViewItems: String {
    case Heuristic
    case BranchAndBound
    case Exhaustive
}
