//
//  AnalysisViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/4/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class AnalysisViewController: NSViewController {

    
    enum Appearance {
        static let maxStickerDimension: CGFloat = 50.0
    }
    
    let imageLoader = ImageLoader(folder: "toolImages")
    var indexPathsOfItemsBeingDragged: Set<NSIndexPath>!
    
    @IBOutlet weak var toolView: NSCollectionView!
    @IBOutlet var destinationView: DestinationView!
    @IBOutlet weak var invitationLabel: NSTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        destinationView.delegate = self
        registerForDragAndDrop()
    
    }
    
    func registerForDragAndDrop() {
        toolView.registerForDraggedTypes([NSPasteboard.PasteboardType.URL])
        toolView.setDraggingSourceOperationMask(.every, forLocal: true)
        toolView.setDraggingSourceOperationMask(.every, forLocal: false)
    }
    
}

// MARK: - NSCollectionViewDelegate methods for handling drag from the collection view

extension AnalysisViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        return true
    }
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        
        let imageFile = imageLoader.getImageFileForPathIndex(indexPath: indexPath as IndexPath)
        return imageFile.url as NSURL
    }
    
}

// MARK: - NSCollectionViewDataSource methods

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

// MARK: - DestinationViewDelegate methods for handling drop on the canvas

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
        let frame = NSRect(x: center.x - constrainedSize.width/2, y: center.y - constrainedSize.height/2, width: constrainedSize.width, height: constrainedSize.height)
        let canvasTool = CanvasTool(image: image, frame: frame)
        destinationView.addSubview(canvasTool.view)
     
        
}

}
