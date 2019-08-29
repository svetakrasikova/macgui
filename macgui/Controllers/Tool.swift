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
        guard isViewLoaded else { return ""}
        if let imageFile = imageFile {
            return imageFile.name
        } else { return "" }
    }
    
    var imageFile: ImageFile? {
        didSet {
            guard isViewLoaded else { return }
            if let imageFile = imageFile {
                imageView?.image = imageFile.image
                textField?.stringValue = imageFile.name
            } else {
                imageView?.image = nil
                textField?.stringValue = ""
            }
        }
    }
    
    override func viewWillAppear() {
        self.view.toolTip = self.name?.prefixWithoutFileExtension()
    }
    
    
}

