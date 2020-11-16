//
//  PaupError.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/10/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

enum PaupViewControllerError: Error {
    case UndefinedTabIdentifier
    case TablessViewControllerError
}

enum PaupTablessViewItems: String {
    case PaupSearch
    case PaupCriterion
    case PaupOverview
}

enum PaupSearchTabViewItems: String {
    case Heuristic
    case BranchAndBound
    case Exhaustive
}
