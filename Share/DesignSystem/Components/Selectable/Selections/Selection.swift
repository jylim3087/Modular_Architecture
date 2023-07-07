//
//  Selection.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/14.
//

import UIKit
import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public final class Selection: SelectableComponent<SelectionStyle> {
    
    // MARK: - Property
    
    public override var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.flex.markDirty()
            setNeedsLayout()
        }
    }
    
    public override var font: UIFont {
        set {
            titleLabel.font = newValue
            titleLabel.flex.markDirty()
            setNeedsLayout()
        }
        get {
            titleLabel.font
        }
    }
    
    override func initLayout() {
        super.initLayout()
        
        titleLabel.textAlignment = .center
        
        flex.direction(.row).paddingHorizontal(20).paddingVertical(16).define { flex in
            flex.addItem(titleLabel).grow(1).shrink(1)
        }
        flex.addItem(button).position(.absolute).all(0)
    }
    
    override func setStyle() {
        super.setStyle()
        
        titleLabel.textColor = style.textColor
    }
}
