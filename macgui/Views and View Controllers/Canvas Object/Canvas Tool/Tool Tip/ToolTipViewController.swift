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
                    if tool.treeDataTool { return }
                    self.setNumberOfMatrices(number: tool.dataMatrices.count)
                },
                tool.observe(\DataTool.unalignedDataMatrices, options: [.initial]) {(tool, change) in
                    if tool.treeDataTool { return }
                    self.setNumberOfMatrices(number: tool.dataMatrices.count)
                },
                tool.observe(\DataTool.trees, options: [.initial]) {(tool, change) in
                    if !tool.treeDataTool { return }
                    self.setNumberOfTrees(number: tool.trees.count)
                },
            ]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.toolNameLabel.stringValue = delegate?.getDescriptiveToolName() ?? "Unnamed Tool"
        setConnectionStatus()
  
        if let delegate = self.delegate as? CanvasToolViewController, let tool = delegate.tool as? DataTool {
            if tool.treeDataTool {
                setNumberOfTrees(number: tool.trees.count)
            } else {
                setNumberOfMatrices(number: tool.dataMatrices.count)
            }
            setDataObserver()
        } else {
            numberMatricesLabel.isHidden = true
        }
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
    
    func setNumberOfTrees(number: Int){
        numberMatricesLabel.stringValue = "# Trees in Set: \(number)"
        self.view.needsDisplay = true
    }
    
}

protocol ToolTipDelegate: class {
    func getDescriptiveToolName() -> String
    func isConnected() -> Bool
}
