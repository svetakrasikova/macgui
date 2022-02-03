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
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var dataCountLabel: NSTextField!
    
    private var observers =  [NSKeyValueObservation]()
    
    func setDataObserver(){
      
        guard let delegate = self.delegate as? CanvasObjectViewController else { return }
        
        if let tool = delegate.tool as? DataTool {
            self.observers = [
                tool.observe(\DataTool.alignedDataMatrices, options: [.initial]) {(tool, _) in
                    guard tool.dataToolType == .matrixData else { return }
                    self.setNumberOfMatrices(number: tool.dataMatrices.count)
                },
                tool.observe(\DataTool.unalignedDataMatrices, options: [.initial]) {(tool, _) in
                    guard tool.dataToolType == .matrixData else { return }
                    self.setNumberOfMatrices(number: tool.dataMatrices.count)
                },
                tool.observe(\DataTool.trees, options: [.initial]) {(tool, _) in
                    guard tool.dataToolType == .treeData else { return }
                    self.setNumberOfTrees(number: tool.trees.count)
                },
                tool.observe(\DataTool.numberData.numberLists, options: [.initial]) {(tool, _) in
                    guard tool.dataToolType == .numberData else { return }
                    self.setNumberOfNumberDataLists(number: tool.numberData.numberLists.count)
                }
            ]
        }
        
        if let tool = delegate.tool as? Loop {
            self.observers = [
                tool.observe(\Loop.upperRange , options: [.initial]) {(tool, _) in
                    self.setLoopRepeats(tool)
                }
                ]
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkConnectionStatus(notification:)),
                                               name: .didConnectTools,
                                               object: nil)
        self.toolNameLabel.stringValue = delegate?.getDescriptiveToolName() ?? "Unnamed Tool"
        setDataObserver()
        setDataCountLabel()
        setStatusLabel()
        preferredContentSize = view.fittingSize
    }
    
    @objc func checkConnectionStatus(notification: Notification) {
        guard let delegate = delegate as? CanvasObjectViewController else { return }
        if let connectable = delegate.tool as? Connectable {
            setConnectionsStatus(connectable.isConnected)
        }
    }
    
    func setStatusLabel() {
        guard let delegate = self.delegate as? CanvasObjectViewController else { return }
        if let status = delegate.isConnected() {
            setConnectionsStatus(status)
        } else {
            if let loop = delegate.tool as? Loop {
                setLoopRepeats(loop)
            }
        }
    }
    func setLoopRepeats(_ loop: Loop) {
        statusLabel.stringValue = "Number of repeats: \(loop.upperRange)"
    }
    
    func setConnectionsStatus(_ status: Bool) {
        statusLabel.stringValue = status ? "Fully connected" : "Missing connections"
    }
    
    func setDataCountLabel() {
        
        if let delegate = self.delegate as? CanvasToolViewController, let tool = delegate.tool as? DataTool {
            switch tool.dataToolType {
            case .matrixData:
                setNumberOfMatrices(number: tool.dataMatrices.count)
            case .treeData:
                setNumberOfTrees(number: tool.trees.count)
            case .numberData:
                setNumberOfNumberDataLists(number: tool.numberData.numberLists.count)
            default: break
            }
            
        } else {
            dataCountLabel.isHidden = true
        }
    }

    func setNumberOfMatrices(number: Int){
        dataCountLabel.stringValue = "# Matrices: \(number)"
        self.view.needsDisplay = true
    }
    
    func setNumberOfTrees(number: Int){
        dataCountLabel.stringValue = "# Trees in Set: \(number)"
        self.view.needsDisplay = true
    }
    
    func setNumberOfNumberDataLists(number: Int){
        dataCountLabel.stringValue = "# Number lists: \(number)"
        self.view.needsDisplay = true
    }
    
}

protocol ToolTipDelegate: AnyObject {
    func getDescriptiveToolName() -> String
    func isConnected() -> Bool?
    
}
