//
//  CharacterCell.swift
//  macgui
//
//  Created by Svetlana Krasikova on 12/2/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CharacterCell: NSTextFieldCell {
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.draw(withFrame: cellFrame, in: controlView)
         backgroundColor = NSColor.red
       
    }

}
