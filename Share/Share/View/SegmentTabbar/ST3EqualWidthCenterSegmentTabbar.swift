//
//  ST3EqualWidthCenterSegmentTabbar.swift
//  DabangSwift
//
//  Created by 유병재 on 2018. 4. 30..
//  Copyright © 2018년 young-soo park. All rights reserved.
//

import UIKit

@IBDesignable public class ST3EqualWidthCenterSegmentTabbar: UIControl {
    
    private var stackView           : UIStackView           = UIStackView()
    private var tabItems            : [ST3EqualWidthCenterSegmentTabItem]   = []
    private var underLineView       : UIView                = UIView()
    private var selectedLineView    : UIView                = UIView()
    
    private var initView    : Bool  = false
    
    public var itemStrings : [String]  = [] {
        didSet {
            self.clearBtns()
            self.initBtns()
            self.updateSelectedLine()
        }
    }
    
    @IBInspectable public var selectedIdx      : Int       = 0 {
        didSet {
            self.updateTabItems()
            self.animateSelectedLine()
        }
    }
    @IBInspectable public var useSubLabel      : Bool      = false {
        didSet { self.updateTabItems() }
    }
    
    @IBInspectable public var underlineColor   : UIColor   = UIColor.fromRed(230, green: 230, blue: 230, alpha: 1.0) {
        didSet { self.updateTabItems() }
    }
    @IBInspectable public var selectLineColor  : UIColor   = UIColor.fromRed(34, green: 34, blue: 34, alpha: 1.0) {
        didSet { self.updateTabItems() }
    }
    
    @IBInspectable public var normalColor      : UIColor   = UIColor.fromRed(102, green: 102, blue: 102, alpha: 1.0) {
        didSet { self.updateTabItems() }
    }
    @IBInspectable public var selectedColor    : UIColor   = UIColor.fromRed(34, green: 34, blue: 34, alpha: 1.0) {
        didSet { self.updateTabItems() }
    }
    @IBInspectable public var subTextColor     : UIColor   = UIColor.fromRed(140, green: 140, blue: 140, alpha: 1.0) {
        didSet { self.updateTabItems() }
    }
    
    public var itemFont               : UIFont    = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.regular)
    public var selectItemFont         : UIFont    = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.bold)
    public var subLabelFont           : UIFont    = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.regular)
    public var selectSubLabelFont     : UIFont    = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.bold)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initStackView()
        self.initUnderLineView()
        self.initBtns()
        self.initSelectedLineView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initStackView()
        self.initUnderLineView()
        self.initBtns()
        self.initSelectedLineView()
    }
    
    public func initStackView() {
        self.stackView.axis = .horizontal
        self.stackView.alignment = .fill
        self.stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func initUnderLineView() {
        underLineView.backgroundColor = underlineColor
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(underLineView)
        
        underLineView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    public func initBtns() {
        self.tabItems = self.itemStrings.map({ (item) -> ST3EqualWidthCenterSegmentTabItem in
            let item = createTabItem(item: item)
            stackView.addArrangedSubview(item)
            return item
        })
        self.updateTabItems()
    }
    
    public func initSelectedLineView() {
        selectedLineView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(selectedLineView)
        
        selectedLineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        self.updateSelectedLine()
    }
    
    public func createTabItem(item:String) -> ST3EqualWidthCenterSegmentTabItem {
        let tabItem = ST3EqualWidthCenterSegmentTabItem(withTitle: item)
        tabItem.itemFont        = self.itemFont
        tabItem.selectedFont    = self.selectItemFont
        tabItem.normalColor     = self.normalColor
        tabItem.selectedColor   = self.selectedColor
        tabItem.subLabelFont    = self.subLabelFont
        tabItem.subTextColor    = self.subTextColor
        tabItem.addTarget(self, action: #selector(ST3EqualWidthCenterSegmentTabbar.itemSelected), for: .valueChanged)
        
        return tabItem
    }
    
    public func updateTabItems() {
        for idx in 0 ..< self.tabItems.count {
            let tabItem = self.tabItems[idx]
            tabItem.itemFont        = self.itemFont
            tabItem.selectedFont    = self.selectItemFont
            tabItem.normalColor     = self.normalColor
            tabItem.selectedColor   = self.selectedColor
            tabItem.subLabelFont    = self.subLabelFont
            tabItem.subTextColor    = self.subTextColor
            tabItem.showSubTitle    = self.useSubLabel
            tabItem.itemSelected    = (self.selectedIdx == idx)
        }
        self.layoutIfNeeded()
    }
    
    public func updateSelectedLine() {
        self.selectedLineView.backgroundColor = self.selectLineColor
        
        if self.selectedIdx > -1 && self.selectedIdx < self.tabItems.count {
            self.selectedLineView.isHidden = false
            let tabItem = self.tabItems[self.selectedIdx]
            
            selectedLayout(tabItem)
            
            setTimeout(after: 300) {
                self.setNeedsLayout()
            }
        } else {
            self.selectedLineView.isHidden = true
        }
    }
    
    public func animateSelectedLine() {
        self.selectedLineView.backgroundColor = self.selectLineColor
        
        if self.selectedIdx > -1 && self.selectedIdx < self.tabItems.count {
            self.selectedLineView.isHidden = false
            let tabItem = self.tabItems[self.selectedIdx]
            
            selectedLayout(tabItem)
            
            if tabItem.frame.width > 0.0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.layoutIfNeeded()
                })
            }
        } else {
            self.selectedLineView.isHidden = true
        }
    }
    
    private func selectedLayout(_ itemView: UIView) {
        selectedLineView.snp.remakeConstraints {
            $0.leading.equalTo(itemView.snp.leading)
            $0.trailing.equalTo(itemView.snp.trailing)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    public func setSelect(selected:Int) {
        if selected > -1 && selected < self.tabItems.count {
            self.selectedIdx = selected
            self.updateTabItems()
        }
    }
    
    public func clearBtns() {
        for view in self.stackView.subviews {
            view.removeFromSuperview()
        }
        self.tabItems = []
    }
    
    @objc func itemSelected(sender: ST3EqualWidthCenterSegmentTabItem) {
        if let idx = self.tabItems.firstIndex(of: sender) {
            self.selectedIdx = idx
            sendActions(for: .valueChanged)
        }
    }
    
    public func itemAtIndex(_ index:Int) -> ST3EqualWidthCenterSegmentTabItem? {
        if index < 0 || index > self.tabItems.count {
            return nil
        }
        return self.tabItems[index]
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if self.selectedIdx > -1 && self.selectedIdx < self.tabItems.count && !self.initView {
            let frame = tabItems[self.selectedIdx].frame
            if frame.width > 0 {
                self.initView = true
                self.selectedLineView.frame = CGRect(x:frame.minX, y:self.bounds.height-2, width:frame.width, height:2)
            }
        }
    }
}
