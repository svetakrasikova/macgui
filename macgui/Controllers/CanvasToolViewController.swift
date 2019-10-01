//
//  CanvasTool.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/12/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasToolViewController: CanvasObjectViewController, NSWindowDelegate, CanvasToolViewDelegate, InfoButtonDelegate, ToolTipDelegate {
    
    weak var tool: ToolObject?
    
    @IBOutlet weak var infoButton: InfoButton!
    @IBOutlet weak var inletsScrollView: NSScrollView!
    @IBOutlet weak var outletsScrollView: NSScrollView!
    @IBOutlet weak var inlets: NSCollectionView!
    @IBOutlet weak var outlets: NSCollectionView!
    @IBOutlet weak var imageView: NSImageView!
    
    let toolTipPopover: NSPopover = NSPopover()
    var popoverLoopTimer: Timer?
    var showPopoverTimer: Timer?
    var showFirstPopoverTimer: Timer?
    

    var image: NSImage {
        guard let tool = self.tool else {
            return NSImage(named: "AppIcon")!
        }
        return NSImage(named: tool.name)!
    }
   
    var frame: NSRect {
        guard let tool = self.tool else {
                   return NSZeroRect
               }
        return tool.frameOnCanvas
    }
    
    
    lazy var sheetViewController: SheetViewController = {
        let vc = NSStoryboard.loadVC(StoryBoardName.modalSheet)  as! SheetViewController
        vc.tool = tool
        return vc
    }()
    
    
    override func keyDown(with event: NSEvent) {
        if event.charactersIgnoringModifiers == String(Character(UnicodeScalar(NSDeleteCharacter)!)) {
            let point = event.locationInWindow
            NotificationCenter.default.post(name: .didSelectDeleteKey, object: self, userInfo: ["point": point])
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        infoButton.mouseEntered(with: event)
            if !toolTipPopover.isShown {
                showFirstPopoverTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(showPopover), userInfo: nil, repeats: false)
                }
            self.popoverLoopTimer = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(popoverLoop), userInfo: nil, repeats: true)
        
    }
    
     @objc func showPopover(){
        self.toolTipPopover.show(relativeTo: self.view.bounds, of: self.view, preferredEdge: NSRectEdge.minY)
    }

    @objc func popoverLoop(){
        self.toolTipPopover.close()
        showPopoverTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(showPopover), userInfo: nil, repeats: false)
    
    }

    
    func closePopover(){
        popoverLoopTimer?.invalidate()
        showPopoverTimer?.invalidate()
        showFirstPopoverTimer?.invalidate()
        self.toolTipPopover.close()
    }
    
    override func mouseExited(with event: NSEvent) {
        infoButton.mouseExited(with: event)
        closePopover()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let window = NSApp.windows.first{
            window.delegate = self
        }
       
        infoButton.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(NSWindowDelegate.windowDidResize(_:)), name: NSWindow.didResizeNotification, object: nil)
        
          NotificationCenter.default.addObserver(self,
                                                     selector: #selector(didAddNewArrow(notification:)),
                                                     name: .didAddNewArrow,
                                                     object: nil)
    
        setFrame()
        setImage()
        setTrackingArea()
        setPopOver()
        
        (self.view as! CanvasToolView).canvasViewToolDelegate = self
        
        
        if tool!.isKind(of: Connectable.self){
                unhideConnectors()
            }
    }
    
    override func viewDidDisappear() {
        closePopover()
    }
    
    @objc func didAddNewArrow(notification: Notification){
        print("updating tool view", self)
        let tools = notification.userInfo as! [String:ToolObject]
        if tool == tools["sourceTool"]{
            outlets.reloadData()
        }
        if tool == tools["targetTool"] {
            inlets.reloadData()
        }
        
    }
    func setPopOver(){
        toolTipPopover.contentViewController = NSStoryboard.loadVC(StoryBoardName.toolTip)
        (toolTipPopover.contentViewController as! ToolTipViewController).delegate = self
    }
    
    func setTrackingArea(){
        let trackingArea = NSTrackingArea(rect: view.bounds,
                                          options: [NSTrackingArea.Options.activeAlways ,NSTrackingArea.Options.mouseEnteredAndExited],
                                          owner: self,
                                          userInfo: nil)
        view.addTrackingArea(trackingArea)
    }

    func unhideConnectors(){
        inletsScrollView.isHidden = false
        outletsScrollView.isHidden = false
    }
    
    
    func setFrame () {
        view.frame = self.frame
    }
    
    func setImage(){
        imageView.image = image
    }
    
    func updateFrame(){
        let size = tool?.frameOnCanvas.size
        let origin = view.frame.origin
        tool?.frameOnCanvas = NSRect(origin: origin, size: size!)
        
    }
    
    func getConnectorItem(_ sender: NSDraggingInfo) -> ConnectorItemView? {
        if let connectionDragController = sender.draggingSource as? ConnectionDragController, let color = connectionDragController.sourceEndpoint?.arrowColor {
            for item in self.inlets.visibleItems() as! [ConnectorItem] {
                let itemView = item.view as! ConnectorItemView
                if itemView.arrowColor == color {
                    return itemView
                }
            }
        }
        return nil
    }
    
    
   func windowDidResize(_ notification: Notification) {
        updateFrame()
    }
    
    func infoButtonClicked() {
        self.presentAsModalWindow(sheetViewController)
    }
    
    func getToolName() -> String {
        if let toolName = self.tool?.descriptiveName { return toolName }
        return "Unnamed Tool"
    }
    
    func isConnected() -> Bool {
        return (self.tool as! Connectable).isConnected
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

