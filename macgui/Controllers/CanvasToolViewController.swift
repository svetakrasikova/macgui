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

    
    init(tool: ToolObject){
        self.image = tool.image
        self.frame = tool.frameOnCanvas
        self.tool = tool
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    override func loadView() {
        self.view = CanvasToolView(image: image, frame: frame)
        (self.view as! CanvasToolView).delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
    }

    
    func setImage(){
        let imageFrame = NSRect(origin: .zero, size: frame.size)
        let subview = NSImageView(frame: imageFrame)
        subview.image = image
        view.addSubview(subview)
    }
//    this method is called when the view frame origin changes
    func updateFrame(){
        let size = tool.frameOnCanvas.size
        let origin = view.frame.origin
        tool.frameOnCanvas = NSRect(origin: origin, size: size)
    }
    
}
