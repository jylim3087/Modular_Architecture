//
//  ChoosableComponent.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/26.
//

import UIKit
import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public class ChoosableComponent<ChoosableStyle: ChoosableStyleSupportable>: UIView, ChoosableComponentable {
    
    // MARK: - UI
    
    private let imageView = UIImageView()
    
    private let titleLabel = Body3_Regular()
    
    private let button = UIButton(type: .custom)
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    
    private var style = ChoosableStyle()
    
    public var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.flex.markDirty()
            setNeedsLayout()
        }
    }
    
    public var font: UIFont {
        set {
            titleLabel.font = newValue
            titleLabel.flex.markDirty()
            setNeedsLayout()
        }
        get {
            titleLabel.font
        }
    }
    
    public var isHiddenTitle: Bool = false {
        didSet {
            titleLabel.isHidden = isHiddenTitle
            titleLabel.flex.isIncludedInLayout(!isHiddenTitle)
        }
    }
    
    public var isSelected: Bool = false {
        didSet {
            style.status(isSelected: isSelected, isEnabled: isEnabled)
            setStyle()
        }
    }
    
    public var isEnabled: Bool = true {
        didSet {
            style.status(isSelected: isSelected, isEnabled: isEnabled)
            setStyle()
        }
    }
    
    public var select = PublishSubject<ChoosableComponentable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initComponent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initComponent()
    }
    
    private func initComponent() {
        initLayout()
        setStyle()
        bind()
    }
    
    private func bind() {
        button.rx.tap
            .compactMap { [weak self] _ in
                self?.isSelected.toggle()
                return self
            }
            .bind(to: select)
            .disposed(by: disposeBag)
    }
}

extension ChoosableComponent {
    private func initLayout() {
        let multiLine = style.multiLine
        titleLabel.numberOfLines = multiLine ? 0 : 1
        
        flex.direction(.row).alignItems(multiLine ? .start : .center).minWidth(24).minHeight(24).define { flex in
            flex.addItem(imageView).width(24).height(24)
            flex.addItem(titleLabel).shrink(1).grow(1).marginLeft(4)
            flex.addItem(button).position(.absolute).all(0)
        }
        
        flex.layout()
    }
    
    private func setStyle() {
        imageView.image = style.toggleImage
        titleLabel.textColor = style.textColor
        button.isEnabled = isEnabled
    }
}
