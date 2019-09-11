//
//  Simulate.swift
//  macgui
//
//  Created by Svetlana Krasikova on 9/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Simulate: Connectable {

    override init(image: NSImage, frameOnCanvas: NSRect) {
        super.init(image: image, frameOnCanvas: frameOnCanvas)
        self.name = "Data Simulation Tool"
        let green = Connector(color:ConnectorColor.green)
        self.inlets = []
        self.outlets = [green]
    }
}
