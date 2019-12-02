//
//  ToolTipViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/13/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ToolTipViewController: NSViewController {
    
    weak var delegate: ToolTipDelegate?
    
    @IBOutlet weak var toolNameLabel: NSTextField!
    @IBOutlet weak var connectionsStatusLabel: NSTextField!
    @IBOutlet weak var numberMatricesLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toolNameLabel.stringValue = delegate?.getDescriptiveToolName() ?? "Unnamed Tool"
        setConnectionStatus()
        if let delegate = self.delegate as? CanvasToolViewController, let tool = delegate.tool as? DataTool {
            let number = tool.dataMatrices.count
            setNumberOfMatrices(number)
        } else {
            numberMatricesLabel.isHidden = true
        }
         NotificationCenter.default.addObserver(self, selector: #selector(setNumberOfMatrices(_:)), name: .didUpdateDataMatrices, object: nil)
    }
    
    func setConnectionStatus() {
        if let delegate = self.delegate {
            if delegate.isConnected() {
                connectionsStatusLabel.stringValue = "Fully connected"
            } else {
                connectionsStatusLabel.stringValue = "Missing connections"
            }
        }
    }
    
    @objc func setNumberOfMatrices(_ number: Int) {
        numberMatricesLabel.stringValue = "# Matrices: \(number)"
        self.view.needsDisplay = true
    }
}

protocol ToolTipDelegate: class {
    func getDescriptiveToolName() -> String
    func isConnected() -> Bool
}
