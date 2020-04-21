//
//  PaletteItem.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/11/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

//constant, rv, function
enum PalettItemType: String, Codable, CaseIterable {
    case move = "Move"
    case variable = "Variable"
    case distribution = "Distribution"
}

class PaletteItem: NSObject, Codable, NSCoding, NSPasteboardWriting, NSPasteboardReading {

    var name: String
    
    enum Key: String {
        case name = "name"
    }
    
    init(name: String) {
        self.name = name
    }

    required convenience init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        guard let data = propertyList as? Data,
            let palettItem = try? PropertyListDecoder().decode(PaletteItem.self, from: data) else { return nil }
        self.init(name: palettItem.name)
    }

    
//   MARK: - NSCoding
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
    }
    
//    MARK: - NSPasteboardWriting, NSPasteboardReading

    
    public func writingOptions(forType type: NSPasteboard.PasteboardType, pasteboard: NSPasteboard) -> NSPasteboard.WritingOptions {
        return .promised
    }

    public func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return [.paletteItem]
    }

    public func pasteboardPropertyList(forType type: NSPasteboard.PasteboardType) -> Any? {
        if type == .paletteItem {
            return try? PropertyListEncoder().encode(self)
        }
        return nil
    }

    public static func readableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return [.paletteItem]
    }

    public static func readingOptions(forType type: NSPasteboard.PasteboardType, pasteboard: NSPasteboard) -> NSPasteboard.ReadingOptions {
        return .asData
    }
}

extension NSPasteboard.PasteboardType {
    static let paletteItem = NSPasteboard.PasteboardType("macgui.paletteItem")
}


