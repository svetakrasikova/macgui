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
   
    var parameters: [PaletteCategory] {
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
        if let parameter = item as? PaletteCategory {
            return parameter.children.count
        }
        if item is PaletteVariable {
            return 3
        }
        return parameters.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let parameter = item as? PaletteCategory {
            return parameter.children[index]
        }
        if let variable = item as? PaletteVariable {
            switch index {
            case 0: return (variable, PaletteVariable.VariableType.constant)
            case 1: return (variable, PaletteVariable.VariableType.function)
            case 2: return (variable, PaletteVariable.VariableType.randomVariable)
            default:
                return (variable, PaletteVariable.VariableType.randomVariable)
            }
        }
        
        if let item = item as? PalettItem, item.type == "Plate" {
            return item
        }
        
        return parameters[index] as Any
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let parameter = item as? PaletteCategory {
            return parameter.children.count > 0
        }
        if item is PaletteVariable {
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
       
        if let parameter = item as? PaletteCategory {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellType.parameterTypeCell.rawValue), owner: self) as? NSTableCellView
            if let textField = view?.textField {
                textField.stringValue = parameter.name
                textField.sizeToFit()
            }
        } else if let parameter = item as? PalettItem {
            let identifier = parameter.type == PalettItem.plateType ? NSUserInterfaceItemIdentifier(rawValue: CellType.shapeCell.rawValue) : NSUserInterfaceItemIdentifier(rawValue: CellType.parameterCell.rawValue)
            view = outlineView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
            if let textField = view?.textField  {
                textField.stringValue = parameter.type
                textField.sizeToFit()
            }
            if let imageView = view?.imageView {
                imageView.image = NSImage(named: "DashedRectangle")
            }
        } else if let parameter = item as? (PaletteVariable, PaletteVariable.VariableType) {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellType.shapeCell.rawValue), owner: self) as? NSTableCellView
            if let textField = view?.textField, let imageView = view?.imageView  {
                switch parameter.1 {
                case .constant:
                    imageView.image = NSImage(named: "SolidRectangle")
                    textField.stringValue = "constant"
                case .function:
                    imageView.image = NSImage(named: "DashedCircle")
                    textField.stringValue = "function"
                case .randomVariable:
                    imageView.image = NSImage(named: "SolidCircle")
                    textField.stringValue = "random variable"
                }
                textField.sizeToFit()
            }
        }
        return view
    }
    
    func outlineView(_ outlineView: NSOutlineView, writeItems items: [Any], to pasteboard: NSPasteboard) -> Bool {
        if let item = items.first as? (PaletteVariable, PaletteVariable.VariableType) {
            pasteboard.clearContents()
            let name = item.0.type
            let type = item.1.rawValue
            let pasteboardString = "\(name):\(type)"
            pasteboard.writeObjects([pasteboardString as NSString])
            return true
        }
        if let item = items.first as? PalettItem, item.type == PalettItem.plateType {
            pasteboard.clearContents()
            let type = item.type
            let pasteboardString = "\(type):\(type)"
            pasteboard.writeObjects([pasteboardString as NSString])
            return true
        }
        return false
    }
    
    // MARK: - Mouse events
    
    @IBAction func doubleClickedItem(_ sender: NSOutlineView) {
        let item = sender.item(atRow: sender.clickedRow)
        if item is PaletteCategory {
            if sender.isItemExpanded(item) {
                sender.collapseItem(item)
            } else {
                sender.expandItem(item)
            }
        }
    }
}

protocol ModelPaletteViewControllerDelegate: AnyObject {
    
}

