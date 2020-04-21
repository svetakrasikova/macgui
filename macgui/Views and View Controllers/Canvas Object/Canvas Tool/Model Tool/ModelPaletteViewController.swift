//
//  ModelPaletteViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/28/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelPaletteViewController: NSViewController {
    
    enum CellType: String {
        case parameterCell = "ParameterCell"
        case parameterTypeCell = "ParameterTypeCell"
        case shapeCell = "ShapeCell"
    }
    
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    weak var delegate: ModelPaletteViewControllerDelegate?
    weak var model: Model?
   
    var parameters: [Parameter] {
        guard let delegate = self.delegate as? ModelToolViewController, let parameters = delegate.parameters else {
            return []
        }
        return parameters
    }
    
    func registerForDragAndDrop() {
        outlineView.registerForDraggedTypes([NSPasteboard.PasteboardType.string])
        outlineView.setDraggingSourceOperationMask(.every, forLocal: false)
    }
    
    //    MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForDragAndDrop()
    }
    
}

// MARK: - NSOutlineViewDataSource
extension ModelPaletteViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let parameter = item as? Parameter {
            return parameter.children.count
        }
        if let item = item as? PalettItem, item.type == .variable {
            return 3
        }
        return parameters.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let parameter = item as? Parameter {
            return parameter.children[index]
        }
        if let palettItem = item as? PalettItem, palettItem.type == .variable {
            switch index {
            case 0: return (palettItem, PaletteVariable.variableType.constant)
            case 1: return (palettItem, PaletteVariable.variableType.function)
            case 2: return (palettItem, PaletteVariable.variableType.randomVariable)
            default: return (palettItem, PaletteVariable.variableType.unknown)
            }
        }
        return parameters[index] as Any
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let parameter = item as? Parameter {
            return parameter.children.count > 0
        }
        if let item = item as? PalettItem, item.type == .variable {
            return true
        }
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, persistentObjectForItem item: Any?) -> Any? {
        return nil
    }
}

// MARK: - NSOutlineViewDelegate
extension ModelPaletteViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        if let parameter = item as? Parameter {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellType.parameterTypeCell.rawValue), owner: self) as? NSTableCellView
            if let textField = view?.textField {
                textField.stringValue = parameter.name
                textField.sizeToFit()
            }
        } else if let parameter = item as? PalettItem {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellType.parameterCell.rawValue), owner: self) as? NSTableCellView
            if let textField = view?.textField  {
                textField.stringValue = parameter.name
                textField.sizeToFit()
            }
        } else if let parameter = item as? (PalettItem, PaletteVariable.variableType) {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellType.shapeCell.rawValue), owner: self) as? NSTableCellView
            if let textField = view?.textField  {
                switch parameter.1 {
                case .constant:
                    textField.stringValue = "constant"
                case .function:
                    textField.stringValue = "function"
                case .randomVariable:
                    textField.stringValue = "random variable"
                default:
                    textField.stringValue = ""
                }
                textField.sizeToFit()
            }
        }
        return view
    }
    
    func outlineView(_ outlineView: NSOutlineView, writeItems items: [Any], to pasteboard: NSPasteboard) -> Bool {
        if let item = items.first as? (PalettItem, PaletteVariable.variableType) {
            pasteboard.clearContents()
            pasteboard.writeObjects([item.0])
            return true
        }
        return false
    }
    
    // MARK: - Mouse events
    
    @IBAction func doubleClickedItem(_ sender: NSOutlineView) {
        let item = sender.item(atRow: sender.clickedRow)
        if item is Parameter {
            if sender.isItemExpanded(item) {
                sender.collapseItem(item)
            } else {
                sender.expandItem(item)
            }
        }
    }
}

protocol ModelPaletteViewControllerDelegate: class {
    
}

