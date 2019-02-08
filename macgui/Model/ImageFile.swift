//
//  ImageFile.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/8/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

// image and its name
struct ImageFile {
    var url: URL
    var image: NSImage
    var name: String
    
    init(url: URL){
        self.name = url.lastPathComponent
        self.url = url
        self.image = NSImage(byReferencing: url)
    }
}
