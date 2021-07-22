//
//  TreePlateViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/18/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreePlateViewController: ResizableCanvasObjectViewController {

    lazy var plateController: TreePlateController = {
        let plateController = NSStoryboard.loadVC(StoryBoardName.treePlateController) as! TreePlateController
        
        if let plate = self.tool as? TreePlate {
            plateController.loop = plate
        }
        if let canvasVC = self.parent as? GenericCanvasViewController {
            plateController.delegate = canvasVC
        }
        return plateController
    }()
    
    var topologyNodeViewController: ModelCanvasItemViewController?
    var edgeViewController: EdgeViewController?
    
    var baseRoot: NSView?
    var baseInternalNodes: NSView?
    var baseTips: NSView?
    
    
    
    override func loadView() {
        if let treePlate = self.tool as? TreePlate {
            view = TreePlateView(frame: treePlate.frameOnCanvas)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBasePanelSubviews()
    }
    
    override func  setBackgroundColor() {
        guard let view = view as? TreePlateView else { return }
        let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
        view.backgroundColor = preferencesManager.modelCanvasBackgroundColor
        
    }
    
    override func actionButtonClicked(_ button: ActionButton) {
        self.presentAsModalWindow(plateController)
    }
    
}

extension TreePlateViewController {
    
    func makeBasePanelView() -> NSView {
        let vw = NSView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.wantsLayer = true
        vw.layer?.backgroundColor = NSColor.clear.cgColor
        return vw
    }
    
    func addBasePanelSubviews() {
        let stackView = NSStackView(views: [makeBasePanelView(),
                                            makeBasePanelView(),
                                            makeBasePanelView()])
         stackView.distribution = .fillEqually
        stackView.orientation = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        for view in stackView.arrangedSubviews {
            view.setContentHuggingPriority(NSLayoutConstraint.Priority(1), for: .horizontal)
            view.setContentHuggingPriority(NSLayoutConstraint.Priority(1), for: .vertical)
        }
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
    }
    
}
