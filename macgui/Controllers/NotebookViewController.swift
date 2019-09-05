//
//  NotebookViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/30/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class NotebookViewController: NSViewController {
    
    weak var analysis: Analysis? 

    override func viewDidLoad() {
        super.viewDidLoad()
        if let analysis = analysis {
            self.title = "RevBayes Notebook for \"" + analysis.name + "\""
        }
    }

}

