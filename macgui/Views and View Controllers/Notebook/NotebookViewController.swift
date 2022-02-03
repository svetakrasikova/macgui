//
//  NotebookViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/30/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class NotebookViewController: NSViewController {
    
    @IBOutlet var textView: NSTextView!
    weak var analysis: Analysis?
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if let analysis = analysis {
            self.view.window?.title = "RevBayes Notebook for \"" + analysis.name + "\""
            self.textView.string = analysis.notes ?? ""
        }
    }
    
    func saveText() {
        self.analysis?.notes = textView.string
    }
    
}

