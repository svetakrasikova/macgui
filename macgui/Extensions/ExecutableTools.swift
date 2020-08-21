//
//  ExecutableTools.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/13/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Foundation

enum ExecutableTool: String {
    case clustal
    case paup
}

enum RunBinaryError: Error {
    case noData
    case writeError
    case launchPathError
}
