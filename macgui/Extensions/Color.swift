//
//  Color.swift
//  macgui
//
//  Created by Svetlana Krasikova on 12/3/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

enum Color {
    case aqua
    case azure
    case beige
    case black
    case blue
    case brown
    case cyan
    case darkblue
    case darkcyan
    case darkgrey
    case darkgreen
    case darkkhaki
    case darkmagenta
    case darkolivegreen
    case darkorange
    case darkorchid
    case darkred
    case darksalmon
    case darkviolet
    case fuchsia
    case gold
    case green
    case indigo
    case khaki
    case lightblue
    case lightcyan
    case lightgreen
    case lightgrey
    case lightpink
    case lightyellow
    case lime
    case magenta
    case maroon
    case navy
    case olive
    case orange
    case pink
    case purple
    case violet
    case red
    case silver
    case white
    case yellow
}

extension Color: RawRepresentable {
    
    typealias RawValue = NSColor
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case NSColor(hexString: "00ffff"): self = .aqua
        case NSColor(hexString: "f0ffff"): self = .azure
        case NSColor(hexString: "f5f5dc"): self = .beige
        case NSColor(hexString: "000000"): self = .black
        case NSColor(hexString: "0000ff"): self = .blue
        case NSColor(hexString: "a52a2a"): self = .brown
        case NSColor(hexString: "00ffff"): self = .cyan
        case NSColor(hexString: "00008b"): self = .darkblue
        case NSColor(hexString: "008b8b"): self = .darkcyan
        case NSColor(hexString: "a9a9a9"): self = .darkgrey
        case NSColor(hexString: "006400"): self = .darkgreen
        case NSColor(hexString: "bdb76b"): self = .darkkhaki
        case NSColor(hexString: "8b008b"): self = .darkmagenta
        case NSColor(hexString: "556b2f"): self = .darkolivegreen
        case NSColor(hexString: "ff8c00"): self = .darkorange
        case NSColor(hexString: "9932cc"): self = .darkorchid
        case NSColor(hexString: "8b0000"): self = .darkred
        case NSColor(hexString: "e9967a"): self = .darksalmon
        case NSColor(hexString: "9400d3"): self = .darkviolet
        case NSColor(hexString: "ff00ff"): self = .fuchsia
        case NSColor(hexString: "ffd700"): self = .gold
        case NSColor(hexString: "008000"): self = .green
        case NSColor(hexString: "4b0082"): self = .indigo
        case NSColor(hexString: "f0e68c"): self = .khaki
        case NSColor(hexString: "add8e6"): self = .lightblue
        case NSColor(hexString: "e0ffff"): self = .lightcyan
        case NSColor(hexString: "90ee90"): self = .lightgreen
        case NSColor(hexString: "d3d3d3"): self = .lightgrey
        case NSColor(hexString: "ffb6c1"): self = .lightpink
        case NSColor(hexString: "ffffe0"): self = .lightyellow
        case NSColor(hexString: "ff00ff"): self = .lime
        case NSColor(hexString: "ff00ff"): self = .magenta
        case NSColor(hexString: "800000"): self = .maroon
        case NSColor(hexString: "000080"): self = .navy
        case NSColor(hexString: "808000"): self = .olive
        case NSColor(hexString: "ffa500"): self = .orange
        case NSColor(hexString: "ffc0cb"): self = .pink
        case NSColor(hexString: "800080"): self = .purple
        case NSColor(hexString: "800080"): self = .violet
        case NSColor(hexString: "ff0000"): self = .red
        case NSColor(hexString: "c0c0c0"): self = .silver
        case NSColor(hexString: "ffffff"): self = .white
        case NSColor(hexString: "ffff00"): self = .yellow
        default: return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .aqua: return NSColor(hexString: "00ffff")
        case .azure: return NSColor(hexString: "f0ffff")
        case .beige: return NSColor(hexString: "f5f5dc")
        case .black: return NSColor(hexString: "000000")
        case .blue: return NSColor(hexString: "0000ff")
        case .brown: return NSColor(hexString: "a52a2a")
        case .cyan: return NSColor(hexString: "00ffff")
        case .darkblue: return NSColor(hexString: "00008b")
        case .darkcyan: return NSColor(hexString: "008b8b")
        case .darkgrey: return NSColor(hexString: "a9a9a9")
        case .darkgreen: return NSColor(hexString: "006400")
        case .darkkhaki: return NSColor(hexString: "bdb76b")
        case .darkmagenta: return NSColor(hexString: "8b008b")
        case .darkolivegreen: return NSColor(hexString: "556b2f")
        case .darkorange: return NSColor(hexString: "ff8c00")
        case .darkorchid: return NSColor(hexString: "9932cc")
        case .darkred: return NSColor(hexString: "8b0000")
        case .darksalmon: return NSColor(hexString: "e9967a")
        case .darkviolet: return NSColor(hexString: "9400d3")
        case .fuchsia: return NSColor(hexString: "ff00ff")
        case .gold: return NSColor(hexString: "ffd700")
        case .green: return NSColor(hexString: "008000")
        case .indigo: return NSColor(hexString: "4b0082")
        case .khaki: return NSColor(hexString: "f0e68c")
        case .lightblue: return NSColor(hexString: "add8e6")
        case .lightcyan: return NSColor(hexString: "e0ffff")
        case .lightgreen: return NSColor(hexString: "90ee90")
        case .lightgrey: return NSColor(hexString: "d3d3d3")
        case .lightpink: return NSColor(hexString: "ffb6c1")
        case .lightyellow: return NSColor(hexString: "ffffe0")
        case .lime: return NSColor(hexString: "ff00ff")
        case .magenta: return NSColor(hexString: "ff00ff")
        case .maroon: return NSColor(hexString: "800000")
        case .navy: return NSColor(hexString: "000080")
        case .olive: return  NSColor(hexString: "808000")
        case .orange: return NSColor(hexString: "ffa500")
        case .pink: return NSColor(hexString: "ffc0cb")
        case .purple: return NSColor(hexString: "800080")
        case .violet: return NSColor(hexString: "800080")
        case .red: return NSColor(hexString: "ff0000")
        case .silver: return NSColor(hexString: "c0c0c0")
        case .white: return NSColor(hexString: "ffffff")
        case .yellow: return NSColor(hexString: "ffff00")
        }
    }
}

extension NSColor {
    
    convenience init(hexString : String)
    {
        if let rgbValue = UInt(hexString, radix: 16) {
            let red   =  CGFloat((rgbValue >> 16) & 0xff) / 255
            let green =  CGFloat((rgbValue >>  8) & 0xff) / 255
            let blue  =  CGFloat((rgbValue      ) & 0xff) / 255
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
}
