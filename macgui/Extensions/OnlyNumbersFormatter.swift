//
//  OnlyNumbersFormatter.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/7/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class OnlyNumbersFormatter: NumberFormatter {
    
    
    override func isPartialStringValid(_ partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString>, proposedSelectedRange proposedSelRangePtr: NSRangePointer?, originalString origString: String, originalSelectedRange origSelRange: NSRange, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if origString.isEmpty {
            return true
        }
        return Double(origString) != nil
        
    }

}
