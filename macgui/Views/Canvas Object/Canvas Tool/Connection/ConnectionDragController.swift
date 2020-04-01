//
//  ConnectionDragController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/21/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ConnectionDragController: NSObject, NSDraggingSource {

    var sourceEndpoint: CanvasObjectView?
    private var lineOverlay: LineOverlay?
    
    func connect(to target: CanvasObjectView) {
        
        if let source = sourceEndpoint as? ConnectorItemView {
            NotificationCenter.default.post(name: .didConnectTools,
            object: self,
            userInfo: ["source": source, "target": target])
        } else if let source = sourceEndpoint as? ModelCanvasItemView {
            NotificationCenter.default.post(name: .didConnectNodes,
            object: self,
            userInfo: ["source": source, "target": target])
        }
    }
        
    
    func trackDrag(forMouseDownEvent mouseDownEvent: NSEvent, in sourceEndpoint: CanvasObjectView) {
        self.sourceEndpoint = sourceEndpoint
        let item = NSDraggingItem(pasteboardWriter: NSPasteboardItem(pasteboardPropertyList: "view", ofType: NSPasteboard.PasteboardType(rawValue: kUTTypeData as String as String))!)
//        setting the frame of dragging item to non-zero to fix the crash after upgrade to Mojave
        item.draggingFrame.size = NSSize(width: 0.1, height: 0.1)
        let session = sourceEndpoint.beginDraggingSession(with: [item], event: mouseDownEvent, source: self)
        session.animatesToStartingPositionsOnCancelOrFail = false
    }
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        switch context {
        case .withinApplication: return .generic
        case .outsideApplication: return []
        @unknown default:
            fatalError()
        }
    }
    
    func draggingSession(_ session: NSDraggingSession, willBeginAt screenPoint: NSPoint) {
        sourceEndpoint?.state = .source
        lineOverlay = LineOverlay(startScreenPoint: screenPoint, endScreenPoint: screenPoint)
    }
    
    func draggingSession(_ session: NSDraggingSession, movedTo screenPoint: NSPoint) {
        lineOverlay?.endScreenPoint = screenPoint
    }
    
    func draggingSession(_ session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        lineOverlay?.removeFromScreen()
        sourceEndpoint?.state = .idle
    }
    
    func ignoreModifierKeys(for session: NSDraggingSession) -> Bool { return true }

}
