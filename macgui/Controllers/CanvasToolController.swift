//
//  CanvasTool.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/12/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasToolController: NSViewController {
    
    var frame: NSRect
    var image: NSImage
    
    init(image: NSImage, frame: NSRect){
        self.image = image
        self.frame = frame
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = CanvasToolView(image: image, frame: frame)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = frame
        view.wantsLayer = true
        setImage()
    }
    
    func setImage(){
        let imageFrame = NSRect(origin: .zero, size: frame.size)
        let subview = NSImageView(frame: imageFrame)
        subview.image = image
        view.addSubview(subview)
    }
    
}
