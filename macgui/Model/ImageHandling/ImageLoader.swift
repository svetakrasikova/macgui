//
//  ImageLoader.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/8/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

struct ImageLoader {
    
    var imageFiles: [ImageFile] {
        var imageFiles = [ImageFile]()
        for type in ToolType.allCases {
            imageFiles.append(ImageFile(name: type))
        }
        return imageFiles
    }
    
    func getImagesCount () -> Int {
        return ToolType.allCases.count
    }
    
    func getImageFileForPathIndex(indexPath: IndexPath) -> ImageFile {
        let imageIndexInImageFiles = indexPath.item
        let imageFile = imageFiles[imageIndexInImageFiles]
        return imageFile
    }
    
}
