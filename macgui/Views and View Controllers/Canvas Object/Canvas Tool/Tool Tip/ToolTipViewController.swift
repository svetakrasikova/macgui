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
    
    private var observers =  [NSKeyValueObservation]()
    
    func setDataObserver(){
        if let delegate = self.delegate as? CanvasToolViewController, let tool = delegate.tool as? DataTool {
            self.observers = [
                tool.observe(\DataTool.alignedDataMatrices, options: [.initial]) {(tool, change) in
                    self.setNumberOfMatrices(number: tool.dataMatrices.count)
                },
                tool.observe(\DataTool.unalignedDataMatrices, options: [.initial]) {(tool, change) in
                    self.setNumberOfMatrices(number: tool.dataMatrices.count)
                } 
            ]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.toolNameLabel.stringValue = delegate?.getDescriptiveToolName() ?? "Unnamed Tool"
        setConnectionStatus()
        if let delegate = self.delegate as? CanvasToolViewController, let tool = delegate.tool as? DataTool {
            setNumberOfMatrices(number: tool.dataMatrices.count)
            } else {
                numberMatricesLabel.isHidden = true
            }
        setDataObserver()
        preferredContentSize = view.fittingSize
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

    
    func setNumberOfMatrices(number: Int){
        numberMatricesLabel.stringValue = "# Matrices: \(number)"
        self.view.needsDisplay = true
    }
    
}

protocol ToolTipDelegate: class {
    func getDescriptiveToolName() -> String
    func isConnected() -> Bool
}
