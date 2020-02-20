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
    }
    
    
    @IBOutlet weak var outlineView: NSOutlineView!
    weak var delegate: ModelPaletteViewControllerDelegate?
    
    weak var tool: Model? {
     guard let delegate = self.delegate as? ModelToolViewController,  let model = delegate.tool as? Model else {
            return nil
        }
         return model
    }
    
    var parameters: [Parameter] {
        guard let delegate = self.delegate as? ModelToolViewController, let parameters = delegate.parameters else {
            return []
        }
        return parameters
    }
    
}

// MARK: - NSOutlineViewDataSource
extension ModelPaletteViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let parameter = item as? Parameter {
            return parameter.children.count
        }
        return parameters.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let parameter = item as? Parameter {
            return parameter.children[index]
        }
        return parameters[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
      if let parameter = item as? Parameter {
        return parameter.children.count > 0
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
            if let textField = view?.textField , let image = view?.imageView {
                //set the image
                textField.stringValue = parameter.name
                textField.sizeToFit()
        }
        }
        return view
    }
    
// MARK: - Mouse and key events
    
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
