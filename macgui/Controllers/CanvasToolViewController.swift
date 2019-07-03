//
//  CanvasTool.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/12/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasToolViewController: CanvasObjectViewController, NSWindowDelegate, CanvasToolViewDelegate {
    

    var tool: ToolObject?
    
    private var observers = [NSKeyValueObservation]()
    
    @IBOutlet weak var inletsScrollView: NSScrollView!
    @IBOutlet weak var outletsScrollView: NSScrollView!
    @IBOutlet weak var inlets: NSCollectionView!
    @IBOutlet weak var outlets: NSCollectionView!
    @IBOutlet weak var imageView: NSImageView!
    
    var frame: NSRect {
        get {
            if let tool = tool {
                return tool.frameOnCanvas
            }
            else {return NSZeroRect}
        }
    }
    var image: NSImage {
        get {
            if let tool = tool {
                return tool.image
            }
            else { return NSImage(named: "AppIcon")!}
        }
    }
    
    lazy var sheetViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "SheetViewController")
            as! NSViewController
    }()
    
    
    override func keyDown(with event: NSEvent) {
        if event.charactersIgnoringModifiers == String(Character(UnicodeScalar(NSDeleteCharacter)!)) {
            let point = event.locationInWindow
            NotificationCenter.default.post(name: .didSelectDeleteKey, object: self, userInfo: ["point": point])
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let window = NSApp.windows.first{
            window.delegate = self
        }
//        observers = [
//            (tool as! Connectable).observe(\Connectable.unconnectedInlets) {tool, change in
//                print("change in unconnectedInlets on tool")},
//            (tool as! Connectable).observe(\Connectable.unconnectedOutlets) {tool, change in
//                print("change in unconnectedOutlets on tool")}
//        ]
        NotificationCenter.default.addObserver(self, selector: #selector(NSWindowDelegate.windowDidResize(_:)), name: NSWindow.didResizeNotification, object: nil)
    
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPushInfo(notification:)),
                                               name: .didPushInfo,
                                               object: nil)
        
        setFrame()
        setImage()
        
        (self.view as! CanvasToolView).canvasViewToolDelegate = self
        
        if let tool = tool {
            if tool.isKind(of: Connectable.self){
                unhideConnectors()
            }
        }
    }


    func unhideConnectors(){
        inletsScrollView.isHidden = false
        outletsScrollView.isHidden = false
    }
    
    
    func setFrame () {
        view.frame = self.frame
    }
    
    func setImage(){
        imageView.image = self.image
    }
    
    func updateFrame(){
        let size = tool!.frameOnCanvas.size
        let origin = view.frame.origin
        tool!.frameOnCanvas = NSRect(origin: origin, size: size)
        
    }
    
   func windowDidResize(_ notification: Notification) {
        updateFrame()
    }
    
    @objc func didPushInfo(notification: Notification) {
        self.presentAsModalWindow(sheetViewController)
    }
    
}

extension CanvasToolViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let connectable = tool as? Connectable else {return 0}
        if collectionView == self.inlets {
            let count = connectable.unconnectedInlets.count
            return count
        } else {
            let count = connectable.unconnectedOutlets.count
            return count
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("ConnectorItem"), for: indexPath) as! ConnectorItem
        item.parentTool = self.tool as? Connectable
        if collectionView == self.inlets {
            item.connector = (self.tool as! Connectable).unconnectedInlets[indexPath.item]
        } else {
            item.connector = (self.tool as! Connectable).unconnectedOutlets[indexPath.item]
        }
        return item
    }
    
}

