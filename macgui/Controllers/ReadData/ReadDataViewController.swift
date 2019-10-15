//
//  ReadDataViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/1/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ReadDataViewController: ToolViewController {
    

    @IBOutlet weak var formatDeterminedBy: NSPopUpButton!
    @IBOutlet weak var dataFormatButton: NSPopUpButton!
    @IBOutlet weak var dataTypeButton: NSPopUpButton!
    @IBOutlet weak var dataAlignment: NSPopUpButton!
    @IBOutlet weak var interleavedFormat: NSPopUpButton!
    
   
    @objc dynamic var formatDeterminedByUser = true
    @objc dynamic var dataTypeSelectable = false
    @objc dynamic var dataAlignmentSelectable = false
    @objc dynamic var interleavedFormatSelectable = false
    @objc dynamic var standardDataTypeSelectable = true
    
    var dataFormat: DataFormat?
    var dataType: DataType = .Standard
    var dataAligned: Bool = true
    var dataInterleaved: Bool = true
    
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
                    dataFormat = .NEXUS
                    dataTypeSelectable = false
                    dataAlignmentSelectable = false
                    interleavedFormatSelectable = false
                case 1:
                    dataFormat = .PHYLIP
                    dataTypeSelectable = true
                    dataAlignmentSelectable = false
                    interleavedFormatSelectable = true
                    standardDataTypeSelectable = true
                case 2:
                    dataFormat = .FASTA
                    dataTypeSelectable = true
                    dataAlignmentSelectable = true
                    interleavedFormatSelectable = false
                    standardDataTypeSelectable = false
                    dataTypeButton.selectItem(withTag: 1)
                default:
                    print("Switch case error!")
                }
    }
    
    @IBAction func selectDataType(_ sender: NSPopUpButton) {
        switch sender.indexOfSelectedItem {
        case 0:
            dataType = .Standard
        case 1:
            dataType = .DNA
        case 2:
            dataType = .RNA
        case 3:
            dataType = .Protein
        default:
            print("Switch case error!")
        }
    }
    
    
    @IBAction func selectDataAlignment(_ sender: NSPopUpButton) {
        switch sender.indexOfSelectedItem {
        case 0:
            dataAligned = true
        case 1:
            dataAligned = false
        default:
            print("Switch case error!")
        }
    }
    
    @IBAction func selectInterleavedFormat(_ sender: NSPopUpButton) {
        switch sender.indexOfSelectedItem {
        case 0:
            dataInterleaved = true
        case 1:
            dataInterleaved = false
        default:
            print("Switch case error!")
        }
    }
    
    
    @IBAction func cancelPushed(_ sender: Any) {
        NotificationCenter.default.post(name: .dismissToolSheet, object: self)
    }
    
    @IBAction func importPushed(_ sender: Any) {
        NotificationCenter.default.post(name: .dismissToolSheet, object: self)
        let panel = NSOpenPanel()
        //        specify allowed file extensions
        panel.allowedFileTypes = []
        panel.begin { [unowned self] result in
            if result == .OK {
                guard let fileURL = panel.url else { return }
                //do something with the file URL
            }
        }
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
