//
//  ClustalViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/16/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ClustalViewController: NSViewController {
    
    @objc dynamic var options: ClustalOptions = ClustalOptions()

    @IBAction func selectAlignement(_ sender: NSPopUpButton) {
        if sender.indexOfSelectedItem == 0 {
            self.options.align = ClustalOptions.Align.full
        } else if  sender.indexOfSelectedItem == 1 {
            self.options.align = ClustalOptions.Align.fast
        }
    }
    @IBAction func selectScoreType(_ sender: NSPopUpButton) {
        if sender.indexOfSelectedItem == 0 {
            self.options.scoreType = ClustalOptions.ScoreType.percent
        } else if  sender.indexOfSelectedItem == 1 {
            self.options.scoreType = ClustalOptions.ScoreType.absolute
        }
    }
    
    @IBAction func selectMatrix(_ sender: NSPopUpButton) {
        if sender.indexOfSelectedItem == 0 {
            self.options.matrix = ClustalOptions.Matrix.gonnet
        } else if  sender.indexOfSelectedItem == 1 {
            self.options.matrix = ClustalOptions.Matrix.blosum
        } else if sender.indexOfSelectedItem == 2 {
            self.options.matrix = ClustalOptions.Matrix.pam
        }
    }
    @IBAction func selectIteration(_ sender: NSPopUpButton) {
        if sender.indexOfSelectedItem == 0 {
            self.options.iteration = ClustalOptions.Iteration.none
        } else if  sender.indexOfSelectedItem == 1 {
            self.options.iteration = ClustalOptions.Iteration.tree
        } else if sender.indexOfSelectedItem == 2 {
            self.options.iteration = ClustalOptions.Iteration.alignment
        }
    }
    @IBAction func selectNoEndGaps(_ sender: NSPopUpButton) {
        if sender.indexOfSelectedItem == 0 {
            self.options.endGaps = ClustalOptions.EndGaps.no
               } else if  sender.indexOfSelectedItem == 1 {
            self.options.endGaps = ClustalOptions.EndGaps.yes
               }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
