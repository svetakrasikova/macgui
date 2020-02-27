//
//  PalettItem.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/11/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

enum PalettItemType: String, Codable, CaseIterable {
    case move = "Move"
    case variable = "Variable"
    case distribution = "Distribution"
}

class PalettItem: NSObject, Codable, NSPasteboardWriting, NSPasteboardReading {
    
    enum PalettItemError: Error {
        case decodingError
        case encodingError
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case type
        case dimension
    }
    
    var name: String
    var type: PalettItemType
    var dimension: Int
    
    init(name: String, type: PalettItemType, dimension: Int) {
        self.name = name
        self.type = type
        self.dimension = dimension
    }
    
    required init(from decoder: Decoder) throws {
        
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try values.decode(String.self, forKey: .name)
            self.type = try values.decode(PalettItemType.self, forKey: .type)
            self.dimension = try values.decode(Int.self, forKey: .dimension)
        }
        catch {
            throw PalettItemError.decodingError
        }
    }
    
    func encode(to encoder: Encoder) throws {
        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(type, forKey: .type)
            try container.encode(dimension, forKey: .dimension)
        } catch {
            throw PalettItemError.encodingError
        }
    }
    
    required convenience init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        guard let data = propertyList as? Data,
            let palettItem = try? PropertyListDecoder().decode(PalettItem.self, from: data) else { return nil }
        self.init(name: palettItem.name, type: palettItem.type, dimension: palettItem.dimension)
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


