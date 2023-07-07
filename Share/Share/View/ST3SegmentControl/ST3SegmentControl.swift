//
//  ST3SegmentControl.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 5. 31..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit

@IBDesignable public class ST3SegmentControl: UIControl {
    
    private var stackView       : UIStackView       = UIStackView()
    private var segmentItems    : [ST3SegmentItem]  = []
    
    @IBInspectable var selectedIdx : Int   = -1 { didSet { self.updateItems() } }
    @IBInspectable var itemsJson        : String {
        get {
            return "[" + self.itemStrings.compactMap { return "\""+$0+"\"" }.joined(separator: ",") + "]"
        }
        set {
            self.itemStrings = parseItemJson(json: newValue)
        }
    }
    @IBInspectable public var radius                   : CGFloat   = -1 { didSet { self.updateItems() } }
    
    @IBInspectable public var selectedTintColor        : UIColor   = .dabangBlue {
        didSet { self.updateItems() }
    }
    @IBInspectable public var unselectedTintColor      : UIColor   = UIColor.white {
        didSet { self.updateItems() }
    }
    @IBInspectable public var selectedBorderColor      : UIColor   = .dabangBlue {
        didSet { self.updateItems() }
    }
    @IBInspectable public var unselectedBorderColor    : UIColor   = UIColor.fromRed(214, green: 214, blue: 214, alpha: 1.0) {
        didSet { self.updateItems() }
    }
    @IBInspectable public var selectedFontColor        : UIColor   = UIColor.white {
        didSet { self.updateItems() }
    }
    @IBInspectable public var unselectedFontColor      : UIColor   = UIColor.fromRed(145, green: 144, blue: 144, alpha: 1.0) {
        didSet { self.updateItems() }
    }
    @IBInspectable public var toggleEnabeled : Bool = false
    
    public var font    : UIFont    = UIFont.systemFont(ofSize: 13.0) {
        didSet { self.updateItems() }
    }
    
    public var itemStrings : [String]  = [] {
        didSet {
            self.clearItems()
            self.initItems()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initStackView()
        self.initItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initStackView()
        self.initItems()
    }
    
    public func initStackView() {
        self.stackView.axis         = .horizontal
        self.stackView.alignment    = .fill
        self.stackView.distribution = .fillEqually
        
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func initItems() {
        self.segmentItems = self.itemStrings.map({ (item) -> ST3SegmentItem in
            let item = createTabItem(item: item)
            stackView.addArrangedSubview(item)
            return item
        })
        self.updateItems()
    }
    
    public func createTabItem(item:String) -> ST3SegmentItem {
        let item = ST3SegmentItem(withTitle: item)
        item.selectedTintColor      = self.selectedTintColor
        item.unselectedTintColor    = self.unselectedTintColor
        item.selectedBorderColor    = self.selectedBorderColor
        item.unselectedBorderColor  = self.unselectedBorderColor
        item.selectedFontColor      = self.selectedFontColor
        item.unselectedFontColor    = self.unselectedFontColor
        item.font                   = self.font
        item.btnRadius              = self.radius
        item.addTarget(self, action: #selector(ST3SegmentControl.tabItem), for: .touchUpInside)
        
        return item
    }
    
    public func updateItems() {
        for idx in 0 ..< self.segmentItems.count {
            var pos : [ST3SegmentItemPos] = []
            if idx == 0 { pos.append(.first) }
            if idx == self.segmentItems.count - 1 { pos.append(.last) }
            let item = self.segmentItems[idx]
            item.selectedTintColor      = self.selectedTintColor
            item.unselectedTintColor    = self.unselectedTintColor
            item.selectedBorderColor    = self.selectedBorderColor
            item.unselectedBorderColor  = self.unselectedBorderColor
            item.selectedFontColor      = self.selectedFontColor
            item.unselectedFontColor    = self.unselectedFontColor
            item.font                   = self.font
            item.btnRadius              = self.radius
            item.pos                    = pos
            item.itemSelected           = (self.selectedIdx == idx)
        }
        self.layoutIfNeeded()
    }
    
    @objc func tabItem(sender: ST3SegmentItem) {
        if let idx = self.segmentItems.firstIndex(of: sender) {
            if self.selectedIdx == idx && self.toggleEnabeled {
                self.selectedIdx = -1
            } else {
                self.selectedIdx = idx
            }
            self.updateItems()
            sendActions(for: .valueChanged)
        }
    }
    
    public func clearItems() {
        for view in self.stackView.subviews {
            view.removeFromSuperview()
        }
        self.segmentItems = []
    }
    
    public func changeString(at idx:Int, to string:String) {
        if idx > -1 && idx < self.segmentItems.count {
            var itemStrings = self.itemStrings
            itemStrings[idx] = string
            self.itemStrings = itemStrings
        }
    }
    
    public func parseItemJson(json:String) -> [String] {
        guard let data = json.data(using: .utf8) else { return [] }
        do {
            guard let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String] else { return [] }
            return result
        } catch {
            return []
        }
    }
}
