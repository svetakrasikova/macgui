//
//  filesNavigatorViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/13/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class FilesNavigatorViewController: NSViewController {
    
    weak var delegate: FilesNavigatorViewControllerDelegate?
    var dataMatrices: [DataMatrix]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

protocol FilesNavigatorViewControllerDelegate: class {
    func setSelectedFile(viewController: FilesNavigatorViewController, selectedFile: String)
}
