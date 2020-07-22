//
//  CanvasTool.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/12/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasToolViewController: CanvasObjectViewController, CanvasToolViewDelegate, ActionButtonDelegate, ToolTipDelegate, ToolObjectDelegate {

    
    @IBOutlet weak var inspectorButton: ActionButton!
    @IBOutlet weak var infoButton: ActionButton!
    @IBOutlet weak var inletsScrollView: NSScrollView!
    @IBOutlet weak var outletsScrollView: NSScrollView!
    @IBOutlet weak var inlets: NSCollectionView!
    @IBOutlet weak var outlets: NSCollectionView!
    @IBOutlet weak var imageView: NSImageView!

    
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
    
   
    var progressSpinner: NSProgressIndicator?
    
    // MARK: - Info Popover Related Properties
    
    let toolTipPopover: NSPopover = NSPopover()
    var startPopoverTimer: Timer?
    var closePopoverTimer: Timer?
    
    @objc func showPopover(){
        if self.view.window?.isMainWindow ?? true, let view = self.view as? MovingCanvasObjectView, view.isMouseDown {
        self.toolTipPopover.show(relativeTo: self.view.bounds, of: self.view, preferredEdge: NSRectEdge.minY)
        }
    }

    func invalidatePopoverTimers() {
        startPopoverTimer?.invalidate()
        closePopoverTimer?.invalidate()
    }
    
    func popOverTimersValid() -> Bool {
        guard let start = startPopoverTimer, let close = closePopoverTimer else { return false }
        return start.isValid && close.isValid
      
    }
    
    @objc func closePopover(){
        if self.toolTipPopover.isShown {
            self.toolTipPopover.close()
        }
        invalidatePopoverTimers()
    }
    
    func setPopOver(){
        toolTipPopover.contentViewController = NSStoryboard.loadVC(StoryBoardName.toolTip)
        if let toolTipPopoverVC = toolTipPopover.contentViewController as? ToolTipViewController{
            toolTipPopoverVC.delegate = self
        }
    }
       
    
    // MARK: - Tool Controller
    
    lazy var sheetViewController: SheetViewController = {
        let vc = NSStoryboard.loadVC(StoryBoardName.modalSheet)  as! SheetViewController
        vc.tool = self.tool
        return vc
    }()

    
    // MARK: - Matrix Inspector Window
    
    private var _matrixInspectorWindowController: InspectorWindowController? = nil
    
    func resetMatrixInspectorWindowController(){
        _matrixInspectorWindowController = nil
    }
    
    var matrixInspectorWindowController: InspectorWindowController {
        if _matrixInspectorWindowController == nil {
            _matrixInspectorWindowController = NSStoryboard.loadWC(StoryBoardName.matrixInspector) as? InspectorWindowController
            _matrixInspectorWindowController!.dataMatrices = (self.tool as! DataTool).dataMatrices
        }
        return _matrixInspectorWindowController!
    }
    
    // MARK: - Model Tool Window
    
    private var _modelToolWindowController: ModelToolWindowController? = nil
    
    func resetModelToolWindowController (){
        _modelToolWindowController = nil
    }
    
    var modelToolWindowController: ModelToolWindowController {
        if _modelToolWindowController == nil, let model = self.tool as? Model {
            _modelToolWindowController = NSStoryboard.loadWC(StoryBoardName.modelTool) as? ModelToolWindowController
            _modelToolWindowController!.tool = model
            _modelToolWindowController!.parameters = PaletteCategory.paletteCategoryList(palettItemsList: model.palettItems)
        }
        return _modelToolWindowController!
    }

    // MARK: - Mouse Events
    
    override func mouseEntered(with event: NSEvent) {
        infoButton.mouseEntered(with: event)
        inspectorButton.mouseEntered(with: event)
        if let view = view as? MovingCanvasObjectView {
            view.isMouseDown = true
            if !self.toolTipPopover.isShown, !view.isMouseDragged, !popOverTimersValid() {
                self.startPopoverTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(showPopover), userInfo: nil, repeats: false)
                self.closePopoverTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(closePopover), userInfo: nil, repeats: false)
            }
        }
        
    }
    
    override func mouseExited(with event: NSEvent) {
        if let view = view as? MovingCanvasObjectView {
                  view.isMouseDown = false
        }
        infoButton.mouseExited(with: event)
        inspectorButton.mouseExited(with: event)
        
        closePopover()
    }
    
    
    // MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoButton.delegate = self
        inspectorButton.delegate = self
        inspectorButton.observeDataChange()
        (self.view as! CanvasToolView).concreteDelegate = self
        tool?.delegate = self
        NotificationCenter.default.addObserver(self,
                                                     selector: #selector(didAddNewArrow(notification:)),
                                                     name: .didAddNewArrow,
                                                     object: nil)
        setUp()
    }
    
    override func viewWillDisappear() {
        if let matrixViewer = _matrixInspectorWindowController, let matrixViewerWindow = matrixViewer.window {
            matrixViewerWindow.close()
        }
        
        if let modelToolCanvas = _modelToolWindowController, let modelToolCanvasWindow = modelToolCanvas.window {
            modelToolCanvasWindow.close()
        }
        
        
        closePopover()
        invalidatePopoverTimers()
        
        
    }
//    override func viewDidDisappear() {
//        closePopover()
//        invalidatePopoverTimers()
//
//    }
    
   
    
    func setUp(){
        setFrame()
        setImage()
        setPopOver()
        if tool!.isKind(of: Connectable.self){ unhideConnectors()}
        addProgressSpinner()
    }
   
    
    // MARK: - View Setup
   
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

    
    // MARK: - Canvas Tool View Delegate
    
    func getConnectorItemArrowView(_ sender: NSDraggingInfo) -> ConnectorItemArrowView? {
        if let connectionDragController = sender.draggingSource as? ConnectionDragController, let source = connectionDragController.sourceEndpoint as? ConnectorItemView, let color = source.connectionColor {
            for item in self.inlets.visibleItems() as! [ConnectorItemArrow] {
                if let itemView = item.view as? ConnectorItemArrowView, itemView.connectionColor == color {
                    return itemView
                }
            }
        }
        return nil
    }
    
    //   MARK: - Progress Indicator
    
    func addProgressSpinner() {
        let center = self.view.bounds.center()
        let indicator = NSProgressIndicator(frame: NSRect(x: center.x - 5, y: center.y - 5, width: 10, height: 10))
        indicator.style = .spinning
        indicator.isHidden = true
        self.view.addSubview(indicator, positioned: .above, relativeTo: imageView)
        progressSpinner = indicator
    }
    
    // MARK: - Tool Object Delegate
    
    func startProgressIndicator() {
        guard let progressSpinner = self.progressSpinner else {
            return
        }
        progressSpinner.isHidden = false
        progressSpinner.startAnimation(self.view)
    }
    
    func endProgressIndicator() {
        guard let progressSpinner = self.progressSpinner else {
            return
        }
        progressSpinner.isHidden = true
        progressSpinner.stopAnimation(self.view)
    }
    
    // MARK: - Action Button Delegate
    func actionButtonClicked(_ button: ActionButton) {
        
        switch button.buttonType {
            
        case .Info:
            if let toolName = tool?.name {
                let toolType = ToolType(rawValue: toolName)
                switch toolType {
                case  .readdata?:
                    (tool as! ReadData).openFileBrowser()
                case .model?:
                    resetModelToolWindowController()
                    modelToolWindowController.showWindow(self)
                default:
                    self.presentAsModalWindow(sheetViewController)
                }
            }
            
        case .Inspector:
            resetMatrixInspectorWindowController()
            matrixInspectorWindowController.showWindow(self)
            
        default:
            print("No default action button implemented.")
        }

        
    }
    
    func inspectorButtonClicked() {
        resetMatrixInspectorWindowController()
        matrixInspectorWindowController.showWindow(self)
    }
    
    func isDisplayDataTool() -> Bool {
        if let tool = self.tool, tool.isKind(of: DataTool.self) {
            let toolType = ToolType(rawValue: tool.name)!
            switch toolType {
            case .readdata:
                return true
            case .align:
                return true
            case .model:
                return false
            default:
                return true
            }
        } else {
            return false
            
        }
    }
    
    // MARK: - Tool Tip Delegate
    
    func isConnected() -> Bool {
        return (self.tool as! Connectable).isConnected
    }
    
    func getDescriptiveToolName() -> String {
           if let toolName = self.tool?.descriptiveName { return toolName }
           return "Unnamed Tool"
       }
    
    // MARK: - Selectors for Observed Notifications
    
    
    @objc func didAddNewArrow(notification: Notification){
        
        let tools = notification.userInfo as! [String:ToolObject]
        if tool == tools["sourceTool"]{
            outlets.reloadData()
        }
        if tool == tools["targetTool"] {
            inlets.reloadData()
        }
    }
    
//   func windowDidResize(_ notification: Notification) {
//           updateFrame()
//       }
//       

}

// MARK: - Inlets and Outlets
extension CanvasToolViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        NSAnimationContext.current.duration = 0
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
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("ConnectorItemArrow"), for: indexPath) as! ConnectorItemArrow
        item.parentTool = self.tool as? Connectable
        if collectionView == self.inlets {
            item.connector = (self.tool as! Connectable).unconnectedInlets[indexPath.item]
        } else {
            item.connector = (self.tool as! Connectable).unconnectedOutlets[indexPath.item]
        }
        return item
    }
    
}
