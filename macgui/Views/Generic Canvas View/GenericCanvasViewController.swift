//
//  GenericCanvasViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/5/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class GenericCanvasViewController: NSViewController, NSWindowDelegate {
    

// MARK: - IB Outlets
    
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var canvasView: GenericCanvasView!
    @IBOutlet weak var transparentToolsView: TransparentToolsView!
    @IBOutlet weak var canvasViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var canvasViewWidthConstraint: NSLayoutConstraint!
    
    

// MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        canvasView.delegate = self
        
        scrollView.magnification = 1.5
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeMagnification(_ :)),
                                               name: NSScrollView.didEndLiveMagnifyNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(changeCanvasObjectControllersSelection(notification:)),
                                                      name: .didSelectCanvasObjectController,
                                                      object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateAppearance), name: UserDefaults.didChangeNotification, object: nil)
    }
    @objc func updateAppearance(){
           canvasView.needsDisplay = true
       }
       
    
    override func viewDidAppear() {
         if let window = view.window  {
                   window.delegate = self
               }

    }
    override func viewDidLayout() {
        super.viewDidLayout()
        canvasViewHeightConstraint.constant = scrollView.frame.size.height * 4
        canvasViewWidthConstraint.constant = scrollView.frame.size.width * 4
    }
    
// MARK: Selection of objects on Canvas
    
    //    deselect all child controllers except the one that sent the notification
    @objc func changeCanvasObjectControllersSelection(notification: Notification){
        let sender = notification.object as! CanvasObjectViewController
        guard sender.parent == self
            else { return }
        for childController in children {
            if childController .isKind(of: CanvasObjectViewController.self) &&
                childController !== sender {
                    (childController as! CanvasObjectViewController).viewSelected = false
                }
            }
        }
    
    // MARK: - Magnification
    
    @IBAction func magnify(_ sender: NSPopUpButton) {
           switch sender.indexOfSelectedItem {
           case 1:
               scrollView.magnification = 0.375
               sender.setTitle("25%")
           case 2:
               scrollView.magnification = 0.75
               sender.setTitle("50%")
           case 3:
               scrollView.magnification = 1.125
               sender.setTitle("75%")
           case 4:
               scrollView.magnification = 1.5
               sender.setTitle("100%")
           case 5:
               scrollView.magnification = 1.875
               sender.setTitle("125%")
           case 6:
               scrollView.magnification = 2.25
               sender.setTitle("1500%")
           case 7:
               scrollView.magnification = 3.0
               sender.setTitle("200%")
           case 8:
               scrollView.magnification = 4.5
               sender.setTitle("300%")
           case 9:
               scrollView.magnification = 6.0
               sender.setTitle("400%")
           default:
               print("Switch case error!")
           }
       }
    
    @objc func didChangeMagnification(_ notification: Notification){
              NotificationCenter.default.post(name: .didChangeMagnification,
                                              object: self,
                                              userInfo: ["magnification": Float(scrollView.magnification)])
          }
    
}

// MARK: - GenericCanvasViewDelegate

extension GenericCanvasViewController: GenericCanvasViewDelegate {
   
    func isMouseDownOnArrowView(event: NSEvent, point: NSPoint) -> Bool {
        for childController in children {
            if childController.isKind(of: ArrowViewController.self){
                let arrowViewController = childController as! ArrowViewController
                let arrowView = ((arrowViewController.view) as! ArrowView)
                if arrowView.clickAreaContains(point: point) {
                    arrowView.mouseDown(with: event)
                    return true
                }
            }
        }
        return false
    }
    
   
    func selectContentView(width: CGFloat) {
        NSColor.lightGray.set()
        let path = NSBezierPath(rect: scrollView.documentVisibleRect)
        path.lineWidth = width
        path.stroke()
    }

     func mouseDownOnCanvasView() {
           for childController in children {
               if childController.isKind(of: CanvasObjectViewController.self){
                   if (childController as! CanvasObjectViewController).viewSelected {
                       (childController as! CanvasObjectViewController).viewSelected = false
                   }
               }
           }
       }
    
    
}
    
