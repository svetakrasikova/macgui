//
//  Model.swift
//  macgui
//
//  Created by Svetlana Krasikova on 9/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Model: Connectable {
    override init(image: NSImage, frameOnCanvas: NSRect) {
        super.init(image: image, frameOnCanvas: frameOnCanvas)
        self.name = "Data Model Tool"
    }
}
