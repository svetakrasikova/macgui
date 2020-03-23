//
//  PalettItem.swift
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

class PalettItem: NSObject, Codable, NSCoding, NSPasteboardWriting, NSPasteboardReading {

    var name: String
    var type: PalettItemType
    var dimension: Int
    
    enum Key: String {
        case name = "name"
        case type = "type"
        case dimension = "dimension"
    }
    
    init(name: String, type: PalettItemType, dimension: Int) {
        self.name = name
        self.type = type
        self.dimension = dimension
    }

    required convenience init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        guard let data = propertyList as? Data,
            let palettItem = try? PropertyListDecoder().decode(PalettItem.self, from: data) else { return nil }
        self.init(name: palettItem.name, type: palettItem.type, dimension: palettItem.dimension)
    }

    
//   MARK: - NSCoding
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(type.rawValue, forKey: "type")
        coder.encode(dimension, forKey: "dimension")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
        type = PalettItemType(rawValue: coder.decodeObject(forKey: Key.type.rawValue) as! String)!
        dimension = coder.decodeInteger(forKey: "dimension")
    }
    
//    MARK: - NSPasteboardWriting, NSPasteboardReading

    
    public func writingOptions(forType type: NSPasteboard.PasteboardType, pasteboard: NSPasteboard) -> NSPasteboard.WritingOptions {
        return .promised
    }

    public func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return [.palettItem]
    }

    public func pasteboardPropertyList(forType type: NSPasteboard.PasteboardType) -> Any? {
        if type == .palettItem {
            return try? PropertyListEncoder().encode(self)
        }
        return nil
    }

    public static func readableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return [.palettItem]
    }

    public static func readingOptions(forType type: NSPasteboard.PasteboardType, pasteboard: NSPasteboard) -> NSPasteboard.ReadingOptions {
        return .asData
    }
}

extension NSPasteboard.PasteboardType {
    static let palettItem = NSPasteboard.PasteboardType("macgui.palettItem")
}


