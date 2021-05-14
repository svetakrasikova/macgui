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
    @IBOutlet weak var dataCountLabel: NSTextField!
    
    private var observers =  [NSKeyValueObservation]()
    
    func setDataObserver(){
        if let delegate = self.delegate as? CanvasToolViewController, let tool = delegate.tool as? DataTool {
            self.observers = [
                tool.observe(\DataTool.alignedDataMatrices, options: [.initial]) {(tool, change) in
                    guard tool.dataToolType == .matrixData else { return }
                    self.setNumberOfMatrices(number: tool.dataMatrices.count)
                },
                tool.observe(\DataTool.unalignedDataMatrices, options: [.initial]) {(tool, change) in
                    guard tool.dataToolType == .matrixData else { return }
                    self.setNumberOfMatrices(number: tool.dataMatrices.count)
                },
                tool.observe(\DataTool.trees, options: [.initial]) {(tool, change) in
                    guard tool.dataToolType == .treeData else { return }
                    self.setNumberOfTrees(number: tool.trees.count)
                },
                tool.observe(\DataTool.numberData.numberLists, options: [.initial]) {(tool, change) in
                    guard tool.dataToolType == .numberData else { return }
                    self.setNumberOfNumberDataLists(number: tool.numberData.numberLists.count)
                },
            ]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.toolNameLabel.stringValue = delegate?.getDescriptiveToolName() ?? "Unnamed Tool"
        setConnectionStatus()
  
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
            setDataObserver()
        } else {
            dataCountLabel.isHidden = true
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
    func isConnected() -> Bool
}
