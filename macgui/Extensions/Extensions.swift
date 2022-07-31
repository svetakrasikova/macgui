//
//  Helpers.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/7/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa


extension NSRect {
    /**
     Get the center point of a rectangle
     
     - returns: NSPoint in the center of the given rectangle
     */
    func center() -> NSPoint {
        let x = origin.x + ( size.width / 2 )
        let y = origin.y + ( size.height / 2 )
        return NSPoint(x: x, y: y)
    }
    
 
}
extension NSPoint {
    /**
     Mutate an NSPoint with a random amount of noise bounded by maximumDelta
     
     - parameter maximumDelta: change range +/-
     
     - returns: mutated point
     */
    func addRandomNoise(_ maximumDelta: UInt32) -> NSPoint {
        
        var newCenter = self
        let range = 2 * maximumDelta
        let xdelta = arc4random_uniform(range)
        let ydelta = arc4random_uniform(range)
        newCenter.x += (CGFloat(xdelta) - CGFloat(maximumDelta))
        newCenter.y += (CGFloat(ydelta) - CGFloat(maximumDelta))
        
        return newCenter
    }
    
    func CGPointDistanceSquaredTo(to: CGPoint) -> CGFloat {
        return (self.x - to.x) * (self.x - to.x) + (self.y - to.y) * (self.y - to.y)
    }
    
    func CGPointDistanceTo(to: CGPoint) -> CGFloat {
        return sqrt(self.CGPointDistanceSquaredTo(to: to))
    }
    
    func adjustOriginToFitContentSize(content: NSSize, dimension: CGFloat) -> NSPoint {
        var newOrigin = self
        if self.x < 0 {
            newOrigin.x = 0
        } else if self.x > content.width - dimension {
            newOrigin.x = content.width - dimension
        }
        
        if self.y < 0 {
            newOrigin.y = 0
        } else if self.y > content.height - dimension {
            newOrigin.y = content.height - dimension
        }
        
        return newOrigin
    }
    
    func selectedAreaTo(point: NSPoint) -> NSRect {
        let origin = NSPoint(x: min(point.x, self.x), y: min(point.y, self.y))
        let width = abs(self.x - point.x)
        let height = abs(self.y - point.y)
        let size = NSSize(width: width, height: height)
        return NSRect(origin: origin, size: size)
     }
    
    func offsetBy(x: CGFloat, y: CGFloat) -> NSPoint {
        return NSPoint(x: self.x + x, y: self.y + y)
    }
    func insetBy(x: CGFloat, y: CGFloat) -> NSPoint {
        return NSPoint(x: self.x - x, y: self.y - y)
    }
}


extension NSView {
    
    func clearSublayers(){
        if let sublayers = layer?.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
    /**
     Take a snapshot of a current state NSView and return an NSImage
     
     - returns: NSImage representation
     */
    func snapshot() -> NSImage {
        let pdfData = dataWithPDF(inside: bounds)
        let image = NSImage(data: pdfData)
        return image ?? NSImage()
    }
    
    
    public func bringToFront() {
        let superlayer = self.layer?.superlayer
        self.layer?.removeFromSuperlayer()
        superlayer?.addSublayer(self.layer!)
    }
    
    
    func  makeGridBackground(dirtyRect: NSRect, gridColor: NSColor, backgroundColor: NSColor){
        
        //Fill background with white color
        if let context = NSGraphicsContext.current?.cgContext {
            backgroundColor.setFill()
            context.fill(dirtyRect)
            context.flush()
        }
        
        //Draw Lines: Horizontal
        for i in 1...(Int(self.bounds.size.height) / 10) {
            if i % 10 == 0 {
                gridColor.withAlphaComponent(0.3).set()
            }else if i % 5 == 0 {
                gridColor.withAlphaComponent(0.2).set()
            }else{
                gridColor.withAlphaComponent(0.1).set()
            }
            
            NSBezierPath.strokeLine(from: NSMakePoint(0, CGFloat(i) * 10 - 0.5), to: NSMakePoint(self.bounds.size.width, CGFloat(i) * 10 - 0.5))
        }
        
        
        //Draw Lines: Vertical
        for i in 1...(Int(self.bounds.size.width) / 10) {
            if i % 10 == 0 {
                gridColor.withAlphaComponent(0.3).set()
            }else if i % 5 == 0 {
                gridColor.withAlphaComponent(0.2).set()
            }else{
                gridColor.withAlphaComponent(0.1).set()
            }
            
            NSBezierPath.strokeLine(from: NSMakePoint(CGFloat(i) * 10 - 0.5, 0), to: NSMakePoint(CGFloat(i) * 10 - 0.5, self.bounds.size.height))
        }
        
    }
    
}

extension NSBezierPath {
    
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo: path.move(to: points[0])
            case .lineTo: path.addLine(to: points[0])
            case .curveTo: path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath: path.closeSubpath()
            @unknown default:
                fatalError()
            }
        }
        return path
    }
    
    
}

extension UserDefaults {
    
    func color(forKey key: String) -> NSColor? {
        
        guard let colorData = data(forKey: key) else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }
        
    }
    func set(_ value: NSColor?, forKey key: String) {
        
        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }
        
    }
}

extension NSWindow {
    
    func dragEndpoint(at point: CGPoint) -> CanvasObjectView? {
        var view = contentView?.hitTest(point)
        while let candidate = view {
            if let endpoint = candidate as? CanvasObjectView { return endpoint }
            view = candidate.superview
        }
        return nil
    }
}


extension NSViewController {
    
    @objc dynamic var defaultsWorkaround: NSUserDefaultsController { return NSUserDefaultsController.shared }

    
}

extension String {
    
    static func lengthOfLongestString(_ strings: [String], fontSize: CGFloat = 12.0) -> CGFloat {
        
     let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: fontSize)
        ]
        var longestStr: CGFloat = 0.0
        for str in strings {
            let attributedString = NSAttributedString(string: str, attributes: attributes)
            let stringLength = attributedString.size().width
            if longestStr < stringLength {
                longestStr = stringLength
            }
        }
        longestStr += 12
        return longestStr
        
    }
    
     func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
    
}

extension FileManager {
    
    class func clearDir(_ path: String) {
        let fm = FileManager.default
        do {
            let filePaths = try fm.contentsOfDirectory(atPath: path)
               for filePath in filePaths {
                   try fm.removeItem(atPath: path + "/" + filePath)
               }
           } catch {
               print("Could not clear temp folder: \(error)")
           }
    }
    
    class func createExeDirForTool(_ toolName: String) {
        let fm = FileManager.default
        let baseUrl = URL(fileURLWithPath: NSTemporaryDirectory())
        let url = baseUrl.appendingPathComponent(toolName)
        var isDirectory = ObjCBool(true)
        let dirExists : Bool = FileManager.default.fileExists(atPath:url.path, isDirectory:&isDirectory)
        guard !dirExists else {
            FileManager.clearDir(url.path)
            return
        }
        do {
            try fm.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return
        } catch let error {
            print("error: \(error)")
        }
    }
    
    class func createDataFileURL(dataFileName: String) -> URL {
        let temporaryDataDirectory = NSTemporaryDirectory()
        var dataFileURL : URL = URL(fileURLWithPath: temporaryDataDirectory)
        dataFileURL.appendPathComponent(dataFileName)
        return dataFileURL
    }
    
    class func createExeScript(dataFileName: String) -> URL  {
        let temporaryDataDirectory = NSTemporaryDirectory()
        var executeFileURL : URL = URL(fileURLWithPath: temporaryDataDirectory)
        executeFileURL.appendPathComponent("execute_" + dataFileName)
        return executeFileURL
    }
    
}


extension NSTabViewController {
    
    func findTabIndexBy(identifierString: String)  -> Int? {
        var index: Int?
        for (i, tabItem) in tabViewItems.enumerated() {
            if tabItem.identifier as! String == identifierString {
                index = i
            }
        }
        return index
    }
   
}

extension NSFont {

    func withTraits(_ traits: NSFontDescriptor.SymbolicTraits) -> NSFont {
        let fd = fontDescriptor.withSymbolicTraits(traits)
        guard let fontWithTraits = NSFont(descriptor: fd, size: pointSize) else {
            return self
        }
        return fontWithTraits
    }

    func italics() -> NSFont {
        return withTraits(.italic)
    }

    func bold() -> NSFont {
        return withTraits(.bold)
    }

    func boldItalics() -> NSFont {
        return withTraits([ .bold, .italic ])
    }
}

extension CATextLayer {
    
    func setAttributedTextWithSubscripts(text: String, indicesOfSubscripts: [Int]) {
        guard let font = self.font else { return }
        let subscriptFont = NSFont(descriptor: font.fontDescriptor, size: font.pointSize * 0.6)?.italics()
        let subscriptOffset = -font.pointSize * 0.3
        let attributedString = NSMutableAttributedString(string: text,
                                                         attributes: [.font : font])
        for index in indicesOfSubscripts {
            let range = NSRange(location: index, length: 1)
            attributedString.setAttributes([.font: subscriptFont as Any,
                                            .baselineOffset: subscriptOffset],
                                           range: range)
        }
        self.string = attributedString
    }
    
    func setAttributedTextWithItalics(text: String, indicesOfSubscripts: [Int]) {
        guard let font = self.font else { return }
        let italicsFont = NSFont(descriptor: font.fontDescriptor, size: font.pointSize)?.italics()
        let attributedString = NSMutableAttributedString(string: text,
                                                         attributes: [.font : font])
        for index in indicesOfSubscripts {
            let range = NSRange(location: index, length: 1)
            attributedString.setAttributes([.font: italicsFont as Any],
                                           range: range)
        }
        self.string = attributedString
    }
    

}

extension NSTableView {
    
    func resizeColumnToFit(columnName: String) {
        
        var longest:CGFloat = 0
        let columnNumber = self.column(withIdentifier: NSUserInterfaceItemIdentifier(columnName))
        let column = self.tableColumns[columnNumber]
        for row in  0..<self.numberOfRows {
            if let view = self.view(atColumn: columnNumber, row: row, makeIfNecessary: true) as? NSTableCellView {
                let width = String.lengthOfLongestString([view.textField!.stringValue])
                if (longest < width) {
                    longest = width
                }
                
            }
           
        }
        
        
        column.width = longest + 20.00
        column.minWidth = longest
    }
}

extension NSAlert {
    
    class func runInfoAlert(message: String, infoText: String?) {
        let alert = NSAlert()
        alert.alertStyle = NSAlert.Style.informational
        alert.messageText = message
        if let info = infoText {
            alert.informativeText = info
        }
        
        alert.runModal()
    }
    
}



