//
//  AnalysisViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/4/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class AnalysisViewController: NSViewController {
   
    let imageLoader = ImageLoader(folder: "toolImages")
    
    enum Appearance {
        static let maxStickerDimension: CGFloat = 150.0
    }
    
    // Collection view of tools
    @IBOutlet weak var toolView: NSCollectionView!
    
    //Subviews of Analysis Edit View
    @IBOutlet weak var targetLayer: NSView!
    @IBOutlet var destinationView: DestinationView!
    @IBOutlet weak var invitationLabel: NSTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        destinationView.delegate = self
        registerForDragAndDrop()
    }
    
    func registerForDragAndDrop() {
        toolView.registerForDraggedTypes([NSPasteboard.PasteboardType.URL])
       
        toolView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: true)
  
        toolView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: false)
    }
    
}

extension AnalysisViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        //return the number of images in toolImages
        return imageLoader.getImagesCount()
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let tool = toolView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Tool"), for: indexPath) as! Tool
        tool.imageFile = imageLoader.getImageFileForPathIndex(indexPath: indexPath)
        return tool
    }
    
    
}

extension AnalysisViewController: DestinationViewDelegate{
    
    func processImageURLs(_ urls: [URL], center: NSPoint) {
        for (_,url) in urls.enumerated() {
            if let image = NSImage(contentsOf: url) {
                processImage(image, center: center)
            }
        }
    }
    
    func processImage(_ image: NSImage, center: NSPoint) {
        
        invitationLabel.isHidden = true
        let constrainedSize = image.aspectFitSizeForMaxDimension(Appearance.maxStickerDimension)

        let subview = NSImageView(frame:NSRect(x: center.x - constrainedSize.width/2, y: center.y - constrainedSize.height/2, width: constrainedSize.width, height: constrainedSize.height))
        subview.image = image
        targetLayer.addSubview(subview)
        
    }
}
