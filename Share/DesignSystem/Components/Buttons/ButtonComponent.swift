//
//  ButtonComponent.swift
//  DabangPro
//
//  Created by 조동현 on 2022/03/03.
//

import UIKit
import RxSwift
import RxCocoa
import FlexLayout
import Then

protocol NewButtonComponentable: UIControl {
    var imageAlignment: ButtonIconAlignment { set get }
    
    func setTitle(_ title: String?, for: UIControl.State)
    func setImage(_ image: UIImage?, for: UIControl.State)
}

public class ButtonComponent: UIControl, NewButtonComponentable {
    
    // MARK: - UI
    
    private let rootView = UIImageView()
    
    private let contentView = UIView()
    
    private let imageView = UIImageView()
    
    private let gapView = UIView()
    
    private let titleLabel = Caption2_Bold()
    
    // MARK: - NewButtonComponentable
    
    public override var isEnabled: Bool {
        didSet {
            setStyle()
            setNeedsLayout()
        }
    }
    
    var imageAlignment: ButtonIconAlignment = .left {
        didSet {
            setDirection()
            setNeedsLayout()
        }
    }
    
    // MARK: - Property
    
    private var titles: [UInt: String] = [:]
    
    private var images: [UInt: UIImage] = [:]
    
    private lazy var isLarge = {
        self as? ButtonLargeHeightSupportable != nil || self as? ButtonXLargeHeightSupportable != nil
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initComponent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initComponent()
    }
    
    private func initComponent() {
        clipsToBounds = true
        layer.borderColor = UIColor.red500.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 2
        
        rootView.isUserInteractionEnabled = false
        
        initLayout()
        initStyle()
        setStyle()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        rootView.pin.all()
        rootView.flex.layout()
    }
}

extension ButtonComponent {
    private func initLayout() {
        addSubview(rootView)
        
        if let heightSupporter = self as? ButtonHeightSupportable {
            rootView.flex.height(heightSupporter.height.rawValue)
            rootView.flex.paddingVertical(heightSupporter.height.paddingVertical)
        }
        
        rootView.flex.direction(.row).justifyContent(.center).alignItems(.stretch).define { flex in
            flex.addItem(contentView).direction(.row).justifyContent(.spaceBetween).alignItems(.center).shrink(1).define { flex in
                flex.addItem(imageView)
                flex.addItem(gapView).width(4).isHidden(false)
                flex.addItem(titleLabel).shrink(1).grow(1).isHidden(false)
            }
        }
    }
    
    private func initStyle() {
        if let heightSupporter = self as? ButtonHeightSupportable {
            titleLabel.font = heightSupporter.titleFont
        }
    }
    
    private func setStyle() {
        setColor()
        setTitle()
        setImage()
        
        let imageHidden = imageView.image == nil
        let titleHidden = titleLabel.text == nil && titleLabel.attributedText == nil
        
        gapView.flex.isHidden(imageHidden || titleHidden)
        imageView.flex.isHidden(imageHidden)
        titleLabel.flex.isHidden(titleHidden)
        
        contentView.flex.justifyContent((imageHidden || titleHidden) ? .center : .spaceBetween)
    }
    
    private func setColor() {
        if let component = self as? ButtonComponentable {
            backgroundColor = isEnabled ? component.enableColor : component.disableColor
            layer.borderColor = (isEnabled ? component.enableBorderColor : component.disableBorderColor).cgColor
        }
        
        if let component = self as? NewButtonTitleSupportable {
            titleLabel.textColor = isEnabled ? component.enableTitleColor : component.disableTitleColor
        }
    }
    
    private func setTitle() {
        let normal = titles[UIControl.State.normal.rawValue]
        
        if !isEnabled, let disabled = titles[UIControl.State.disabled.rawValue] {
            titleLabel.text = disabled
        } else {
            titleLabel.text = normal
        }
        
        titleLabel.flex.markDirty()
    }
    
    private func setImage() {
        let normal = images[UIControl.State.normal.rawValue]
        
        if !isEnabled, let disabled = images[UIControl.State.disabled.rawValue] {
            imageView.image = disabled
        } else {
            imageView.image = normal
        }
    }
    
    private func setDirection() {
        switch imageAlignment {
        case .left:
            contentView.flex.direction(.row)
        case .right:
            contentView.flex.direction(.rowReverse)
        case .top:
            if isLarge {
                contentView.flex.direction(.column)
            }
        case .bottom:
            if isLarge {
                contentView.flex.direction(.columnReverse)
            }
        }
        
        if let heightSupporter = self as? ButtonHeightSupportable {
            titleLabel.font = imageAlignment.isVertical && isLarge ? heightSupporter.verticalTitleFont : heightSupporter.titleFont
            titleLabel.flex.markDirty()
        }
    }
}

// MARK: - NewButtonCompotable

extension ButtonComponent {
    func setTitle(_ title: String?, for: UIControl.State) {
        titles[`for`.rawValue] = title
        
        setStyle()
        setNeedsLayout()
    }
    
    func setImage(_ image: UIImage?, for: UIControl.State) {
        images[`for`.rawValue] = image
        
        setStyle()
        setNeedsLayout()
    }
}

extension Reactive where Base: ButtonComponent {
    var tap: ControlEvent<Void> {
        controlEvent(.touchUpInside)
    }
}

class ButtonComponentXLarge: ButtonComponent, NewButtonIconSupportable, NewGrayLineButtonStyle, ButtonXLargeHeightSupportable {}

protocol NewButtonTitleSupportable: NewButtonComponentable {
    var enableTitleColor: UIColor { get }
    var disableTitleColor: UIColor { get }
    
    func setTitle(_ title: String)
}

extension NewButtonTitleSupportable {
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
}

protocol NewButtonIconSupportable: NewButtonComponentable {
    func setIcon(_ icon: UIImage?, _ alignment: ButtonIconAlignment)
}

extension NewButtonIconSupportable {
    func setIcon(_ icon: UIImage?, _ alignment: ButtonIconAlignment = .left) {
        setImage(icon, for: .normal)
        imageAlignment = alignment
    }
}

protocol NewBlueLineButtonTitleSupportable: NewButtonTitleSupportable {}

extension NewBlueLineButtonTitleSupportable {
    var enableTitleColor: UIColor { .blue500 }
    var disableTitleColor: UIColor { .gray500 }
}

protocol NewGrayLineButtonTitleSupportable: NewButtonTitleSupportable {}

extension NewGrayLineButtonTitleSupportable {
    var enableTitleColor: UIColor { .gray900 }
    var disableTitleColor: UIColor { .gray500 }
}

protocol NewBlueLineButtonStyle: BlueLineButtonComponentable, NewBlueLineButtonTitleSupportable {}

protocol NewGrayLineButtonStyle: GrayLineButtonComponentable, NewGrayLineButtonTitleSupportable {}
