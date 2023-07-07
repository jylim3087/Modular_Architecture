//
//  ST3EqualWidthCenterSegmentTabItem.swift
//  DabangSwift
//
//  Created by 유병재 on 2018. 4. 30..
//  Copyright © 2018년 young-soo park. All rights reserved.
//

import UIKit

public class ST3EqualWidthCenterSegmentTabItem : UIControl {
    
    private var button          : UIButton      = UIButton()
    private var titleStackView  : UIStackView   = UIStackView()
    private var titleView       : UIView        = UIView()
    private var titleLabel      : UILabel       = UILabel()
    private var subLabel        : UILabel       = UILabel()
    
    var normalColor     : UIColor   = UIColor.fromRed(47, green: 47, blue: 47, alpha: 1.0) { didSet { self.updateTitleLabel() } }
    var selectedColor   : UIColor   = UIColor.fromRed(17, green: 113, blue: 235, alpha: 1.0) { didSet { self.updateTitleLabel() } }
    var subTextColor    : UIColor   = UIColor.fromRed(140, green: 140, blue: 140, alpha: 1.0) { didSet { self.updateSubLabel() } }
    var selectedFont    : UIFont    = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.bold) { didSet { self.updateTitleLabel() } }
    
    var itemSelected    : Bool      = false { didSet { self.updateTitleLabel() } }
    var showSubTitle    : Bool      = false { didSet { self.updateSubLabel() } }
    
    var title           : String    = "" { didSet { self.updateTitleLabel() } }
    var subTitle        : String    = "" { didSet { self.updateSubLabel() } }
    
    var itemFont        : UIFont    = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.regular) { didSet { self.updateTitleLabel() } }
    var subLabelFont    : UIFont    = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular) { didSet { self.updateSubLabel() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initTitleView()
        self.initButton()
        self.updateTitleLabel()
        self.updateSubLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initTitleView()
        self.initButton()
        self.updateTitleLabel()
        self.updateSubLabel()
    }
    
    init(withTitle title:String) {
        super.init(frame: CGRect.zero)
        self.title = title
        self.initTitleView()
        self.initButton()
        self.updateTitleLabel()
        self.updateSubLabel()
    }
    
    func initButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(ST3EqualWidthCenterSegmentTabItem.clickBtn), for: .touchUpInside)
        
        addSubview(button)
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.updateTitleLabel()
    }
    
    func initTitleView() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleView)
        
        titleView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.initTitleStackView()
    }
    
    func initTitleStackView() {
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(titleStackView)
        
        titleStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleStackView.alignment = .fill
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fill
        titleStackView.spacing = 0.0
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subLabel)
        titleLabel.textAlignment = .center
        subLabel.textAlignment = .left
    }
    
    func updateTitleLabel() {
        self.titleLabel.textColor = (self.itemSelected) ? self.selectedColor : self.normalColor
        self.titleLabel.font = (self.itemSelected) ? self.selectedFont : self.itemFont
        self.titleLabel.text = self.title
    }
    
    func updateSubLabel() {
        self.subLabel.textColor = self.subTextColor
        self.subLabel.font = self.subLabelFont
        self.subLabel.text = self.subTitle
        self.subLabel.isHidden = !self.showSubTitle
    }
    
    @objc func clickBtn(sender: Any?) {
        if !self.itemSelected {
            self.itemSelected = true
            sendActions(for: .valueChanged)
        }
    }
}
