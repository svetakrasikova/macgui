//
//  CanvasTool.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/12/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasToolViewController: NSViewController, CanvasToolViewDelegate {
    
    
    var frame: NSRect
    var image: NSImage
    var tool: ToolObject
    var shiftKeyPressed: Bool = false
    var viewSelected: Bool = false {
        didSet {
            (view as! CanvasToolView).isSelected = viewSelected
            if viewSelected && !shiftKeyPressed {
                NotificationCenter.default.post(name: .didSelectToolController, object: self)
            }
        }
    }
    

    @IBOutlet weak var inletsScrollView: NSScrollView!
    @IBOutlet weak var outletsScrollView: NSScrollView!
    @IBOutlet weak var inlets: NSCollectionView!
    @IBOutlet weak var outlets: NSCollectionView!
    @IBOutlet weak var imageView: NSImageView!
    
  
    init(tool: ToolObject){
        self.image = tool.image
        self.frame = tool.frameOnCanvas
        self.tool = tool
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        // set some defaults
        image = NSImage(named: "AppIcon")!
        frame = NSRect(origin: .zero, size: NSSize(width: 50, height: 50))
        tool = ToolObject(image: image, frameOnCanvas: frame)
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // set the frame of the tool view and add image to the image view
        setFrame()
        setImage()
        
        
        // set self as the delegate of the view
        (self.view as! CanvasToolView).canvasViewToolDelegate = self
        
        // if it is a connectable tool add inlets and outlets
        if tool .isKind(of: Connectable.self){
           unhideConnectors()
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
    
//    this method is called when the view frame origin changes
    func updateFrame(){
        let size = tool.frameOnCanvas.size
        let origin = view.frame.origin
        tool.frameOnCanvas = NSRect(origin: origin, size: size)
    }
    
    func setViewSelected(flag: Bool) {
        shiftKeyPressed = flag
        viewSelected = true
        
    }
    
}

extension CanvasToolViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let connectable = tool as? Connectable else {return 0}
        if collectionView == self.inlets {
            return connectable.inlets.count
        } else {
            return connectable.outlets.count
        }
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("ConnectorItem"), for: indexPath) as! ConnectorItem
        if collectionView == self.outlets {
            item.type = (self.tool as! Connectable).outlets[indexPath.item]
        } else {
            item.type = (self.tool as! Connectable).inlets[indexPath.item]
        }
        return item
    }
    
}
