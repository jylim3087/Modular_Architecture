//
//  ST3SegmentItem.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 5. 31..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit
import SnapKit

enum ST3SegmentItemPos  : Int {
    case first  = 1
    case last   = 2
}

public class ST3SegmentItem: UIControl {
    var itemSelected    : Bool                  = false { didSet { self.updateViews() } }
    var pos             : [ST3SegmentItemPos]   = [] { didSet { self.updateViews() } }
    private var btn             : UIButton              = UIButton()
    private var label           : UILabel               = UILabel()
    private var item            : String                = "" { didSet { self.updateViews() } }
    var itemString : String { return self.item }
    
    var btnRadius               : CGFloat   = -1 { didSet { self.updateViews() } }
    var selectedTintColor       : UIColor   = UIColor.dabangBlue {
        didSet { self.updateViews() }
    }
    var unselectedTintColor     : UIColor   = UIColor.white
    var selectedBorderColor     : UIColor   = UIColor.dabangBlue {
        didSet { self.updateViews() }
    }
    var unselectedBorderColor   : UIColor   = UIColor.fromRed(214, green: 214, blue: 214, alpha: 1.0) {
        didSet { self.updateViews() }
    }
    var selectedFontColor       : UIColor   = UIColor.white {
        didSet { self.updateViews() }
    }
    var unselectedFontColor     : UIColor   = UIColor.fromRed(145, green: 144, blue: 144, alpha: 1.0) {
        didSet { self.updateViews() }
    }
    var font                    : UIFont    = UIFont.systemFont(ofSize: 13.0)
    
    var radius  : CGFloat {
        if btnRadius < 0 {
           return min(self.bounds.width, self.bounds.height) / 2.0
        } else {
            return btnRadius
        }
        
    }
    var isFirst : Bool { return self.pos.firstIndex(of: .first) != nil }
    var isLast  : Bool { return self.pos.firstIndex(of: .last) != nil }
    var radii   : CGSize { return CGSize(width: self.radius, height: self.radius) }
    
    var maskPath    : UIBezierPath {
        var bounds = self.bounds
        bounds.origin.y = 1
        bounds.size.height -= 2
        var maskPath    : UIBezierPath = UIBezierPath(rect: bounds)
        if self.isFirst && self.isLast {
            bounds.origin.x = 1
            bounds.size.width -= 2
            maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: self.radii)
        } else if self.isFirst {
            bounds.origin.x += 1
            bounds.size.width -= 1
            maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: self.radii)
        } else if self.isLast {
            bounds.size.width -= 1
            maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: self.radii)
        }
        return maskPath
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initLabel()
        self.initButton()
        self.updateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initLabel()
        self.initButton()
        self.updateViews()
    }
    
    init(withTitle title:String) {
        super.init(frame: CGRect.zero)
        self.item = title
        self.initLabel()
        self.initButton()
        self.updateViews()
    }
    
    func initLabel() {
        self.addSubview(self.label)
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(5)
            $0.right.equalTo(-5)
        }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        label.font = self.font
    }
    
    func initButton() {
        self.addSubview(self.btn)
        btn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        btn.addTarget(self, action: #selector(ST3SegmentItem.tapBtn), for: .touchUpInside)
    }
    
    @objc func tapBtn(sender : Any) {
        self.sendActions(for: .touchUpInside)
    }
    
    func updateViews() {
        self.backgroundColor    = UIColor.clear
        self.label.textColor    = (self.itemSelected) ? selectedFontColor : unselectedFontColor
        self.label.text         = self.item
        self.label.font = self.font
        self.setNeedsDisplay()
    }
    
    func drawFill() {
        let fillColor       = (self.itemSelected) ? selectedTintColor : unselectedTintColor
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(fillColor.cgColor)
        self.maskPath.fill()
    }
    
    func drawOutline() {
        let outlineColor    = (self.itemSelected) ? selectedBorderColor : unselectedBorderColor
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1.0)
        context?.setStrokeColor(outlineColor.cgColor)
        context?.addPath(self.maskPath.cgPath)
        context?.strokePath()
        
        self.setNeedsDisplay()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawFill()
        self.drawOutline()
    }
}
