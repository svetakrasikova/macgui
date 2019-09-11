//
//  Summarize.swift
//  macgui
//
//  Created by Svetlana Krasikova on 9/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreeSet: Connectable {
    override init(image: NSImage, frameOnCanvas: NSRect) {
        super.init(image: image, frameOnCanvas: frameOnCanvas)
        self.name = "Tree Set Tool"
        self.inlets = [Connector(color:ConnectorColor.red)]
        self.outlets = [Connector(color:ConnectorColor.orange)]
    }
}
