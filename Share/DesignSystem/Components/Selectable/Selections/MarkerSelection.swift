//
//  MarkerSelection.swift
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

public final class MarkerSelection: SelectableComponent<MarkerSelectionStyle> {
    
    // MARK: - UI
    
    private let imageView = UIImageView().then {
        $0.isHidden = true
    }
    
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
        
        imageView.image = style.toggleImage
        
        flex.direction(.row).justifyContent(.spaceBetween).alignItems(.center).paddingHorizontal(20).paddingVertical(16).define { flex in
            flex.addItem(titleLabel).shrink(1).grow(1)
            flex.addItem(imageView).width(24).height(24)
        }
        flex.addItem(button).position(.absolute).all(0)
    }
    
    override func setStyle() {
        super.setStyle()
        
        titleLabel.textColor = style.textColor
        
        if imageView.flex.isIncludedInLayout {
            imageView.isHidden = !isSelected
        }
    }
}
