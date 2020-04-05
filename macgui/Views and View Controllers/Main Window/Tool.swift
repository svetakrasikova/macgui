//
//  Tool.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/4/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Tool: NSCollectionViewItem {
    
    var name: String? {
        didSet {
            guard isViewLoaded else { return }
            if let name = name {
                textField?.stringValue = name
            } else {
                textField?.stringValue = ""
            }
        }
    }
    
    var image: NSImage? {
        didSet {
            guard isViewLoaded else { return }
            if let image = image {
                imageView?.image = image
            } else {
                imageView?.image = nil
            }
        }
    }
    
    override func viewWillAppear() {
        self.view.toolTip = self.name
    }
    
    
}

