//
//  SummaryViewConroller.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/20/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class SummaryViewConroller: NSViewController {
    
    var type: SummaryType? {
        guard let delegate = self.delegate else { return nil }
        return delegate.summaryType()
    }
    
    var options: PaupOptions? {
        guard let delegate = self.delegate else { return nil }
        return delegate.getSummaryData() as? PaupOptions
    }
    
    var column1: NSStackView!
    var column2: NSStackView!
    
    weak var delegate: SummaryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func updateSummary() {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        if let type = self.type {
            addStackViews(optionLabels: optionsByType(type))
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        updateSummary()
        
    }
    
    
    func optionsByType(_ type: SummaryType) -> [String] {
        if let options = self.options {
            switch type {
            case .heuristicSearch: return options.holisticSearchSummary()
            case .branchAndBoundSearch: return options.branchAndBoundSearchSummary()
            case .exhaustiveSearch: return options.exhaustiveSearchSummary()
            case .likelihood: return options.likelihoodSummary()
            case .distance: return options.distanceSummary()
            case .parsimony: return options.parsimonySummary()
            default: break
            }
        }
        return [String]()
    }
    
}
    
extension SummaryViewConroller {
    
    func addStackViews(optionLabels: [String]) {
        if optionLabels.count < 7 {
            column1 = initVerticalStackView()
            view.addSubview(column1)
            layoutOneColumn()
            for option in optionLabels {
                addRow(column: column1, label: option)
            }
        } else {
            column1 = initVerticalStackView()
            column2 = initVerticalStackView()
            view.addSubview(column1)
            view.addSubview(column2)
            layoutTwoColumns()
            var evenOptionLabels = optionLabels
            if optionLabels.count%2 != 0 {
                evenOptionLabels.append("")
            }
            for label in evenOptionLabels.prefix(evenOptionLabels.count/2) {
                addRow(column: column1, label: label)
            }
            for label in evenOptionLabels.suffix(evenOptionLabels.count/2) {
                addRow(column: column2, label: label)
            }
        }
    }
    
    func initVerticalStackView() -> NSStackView {
        let rows = NSStackView()
        rows.orientation = .vertical
        rows.alignment = .leading
        rows.distribution = .fill
        rows.translatesAutoresizingMaskIntoConstraints = false
        return rows
    }
    
    func layoutTwoColumns() {
        
        column1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        column1.trailingAnchor.constraint(equalTo: column2.leadingAnchor, constant: -20.0).isActive = true
        column2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        column1.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0).isActive = true
        column1.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0).isActive = true
        column2.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0).isActive = true
        column2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0).isActive = true
    }
    
    func layoutOneColumn() {
        column1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        column1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        column1.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0).isActive = true
        column1.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0).isActive = true
    }
    
    
    func addRow(column: NSStackView, label: String) {
        let row = NSStackView(views: [makeOptionLabel(stringValue: label)])
        row.distribution = .fillEqually
        column.addArrangedSubview(row)
    }
    
    
    
    func makeOptionLabel(stringValue: String) -> NSTextField {
        let label = NSTextField()
        label.isEditable = false
        label.isSelectable = false
        label.textColor = .labelColor
        label.drawsBackground = false
        label.isBezeled = false
        label.alignment = .natural
        label.font = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: label.controlSize))
        label.cell?.isScrollable = true
        label.cell?.wraps = false
        label.stringValue = stringValue
        return label
    }
    
}


protocol SummaryViewControllerDelegate: AnyObject {
    func summaryType() -> SummaryType
    func getSummaryData() -> Any?
}
