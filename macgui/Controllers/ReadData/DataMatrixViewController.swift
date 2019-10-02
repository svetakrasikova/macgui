//
//  DataMatrixViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/1/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class DataMatrixViewController: NSViewController {

    @IBOutlet weak var formatDeterminedBy: NSPopUpButton!
    @IBOutlet weak var dataFormat: NSPopUpButton!
    @IBOutlet weak var dataType: NSPopUpButton!
    @IBOutlet weak var dataAlignment: NSPopUpButton!
    @IBOutlet weak var interleavedFormat: NSPopUpButton!
    
    
   
    @objc dynamic var formatDeterminedByUser = true
    @objc dynamic var dataTypeSelectable = false
    @objc dynamic var dataAlignmentSelectable = false
    @objc dynamic var interleavedFormatSelectable = false
    @objc dynamic var standardDataTypeSelectable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectFormatDetermined(_ sender: NSPopUpButton) {
        switch sender.indexOfSelectedItem {
        case 0:
            formatDeterminedByUser = true
        case 1:
            formatDeterminedByUser = false
        default:
            print("Switch case error!")
        }
    }
    @IBAction func selectDataFormat(_ sender: NSPopUpButton) {
          switch sender.indexOfSelectedItem {
                case 0:
                    dataTypeSelectable = false
                    dataAlignmentSelectable = false
                    interleavedFormatSelectable = false
                case 1:
                    dataTypeSelectable = true
                    dataAlignmentSelectable = false
                    interleavedFormatSelectable = true
                    standardDataTypeSelectable = true
                case 2:
                    dataTypeSelectable = true
                    dataAlignmentSelectable = true
                    interleavedFormatSelectable = false
                    standardDataTypeSelectable = false
                default:
                    print("Switch case error!")
                }
    }
    
    @IBAction func selectDataType(_ sender: NSPopUpButton) {
    }
    @IBAction func selectDataAlignment(_ sender: NSPopUpButton) {
    }
    @IBAction func selectInterleavedFormat(_ sender: NSPopUpButton) {
    }
    
    
}

enum DataFormat {
    case NEXUS
    case PHYLIP
    case FASTA
}

enum DataType {
    case Standard
    case DNA
    case RNA
    case Protein
    
}
