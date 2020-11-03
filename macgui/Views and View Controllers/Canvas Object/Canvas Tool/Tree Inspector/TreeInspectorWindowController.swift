//
//  TreeInspectorWindowController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/14/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreeInspectorWindowController: NSWindowController {
    
    
    let verticalCoverage: CGFloat = 0.95
    let widthToHeightRatio: CGFloat = 0.75
    var trees: [Tree]?
    var toolType: String? {
        didSet {
            self.window?.title = (toolType ?? "Tree") + " Viewer"
        }
    }
    
   
    override func windowDidLoad() {
        super.windowDidLoad()
        adjustFrame(verticalCoverage: verticalCoverage, widthToHeightRatio: widthToHeightRatio)
    }
    
    func adjustFrame(verticalCoverage: CGFloat, widthToHeightRatio: CGFloat) {
        if let screenRect: NSRect = NSScreen.main?.visibleFrame, var frame = window?.frame {
            let height = screenRect.size.height * verticalCoverage
            frame.size.height = screenRect.size.height * verticalCoverage
            frame.size.width = height  * widthToHeightRatio
            window?.setFrame(frame, display: true)
        }
    }

}
