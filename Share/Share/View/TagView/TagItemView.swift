//
//  TagItemView.swift
//  DabangSwift
//
//  Created by jiyeonpark on 2023/04/13.
//

import Foundation
import PinLayout
import FlexLayout
import SkeletonView
import UIKit

public class TagItemView: UIView {
    // MARK: UI
    private let containerView = UIView().then {
        $0.isSkeletonable = true
        $0.isHiddenWhenSkeletonIsActive = true
    }
    
    private let textLabel = UILabel()
    
    // MARK: Property
    private let style: Style
    private let font: UIFont
    private let marginHorizontal: CGFloat
    
    public var text: String {
        get {
            textLabel.text ?? ""
        }
        
        set {
            textLabel.text = newValue
            textLabel.flex.markDirty()
            containerView.flex.layout(mode: .adjustWidth)
        }
    }
    
    // MARK: Method
    init(style: Style,
         isBold: Bool = false,
         marginHorizontal: CGFloat = 6,
         radius: CGFloat = 2) {
        self.style = style
        self.font = isBold ? .caption1_bold : .caption1_regular
        self.marginHorizontal = marginHorizontal
        
        super.init(frame: .zero)
        
        containerView.cornerRadius = radius
        
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        textLabel.textColor = style.textColor
        textLabel.font = font
        
        flex.addItem(containerView).direction(.row).define {
            $0.backgroundColor(style.fillColor)
            
            $0.view?.borderColor = isSkeletonActive ? .clear : style.borderColor
            $0.view?.borderWidth = 1
            $0.view?.clipsToBounds = true
            $0.addItem(textLabel).marginHorizontal(marginHorizontal).alignSelf(.center)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.pin.all()
        textLabel.pin.top().bottom().left(marginHorizontal).right(marginHorizontal)
        containerView.flex.layout(mode: .adjustWidth)
    }
    
    public func update(isShowSkeleton: Bool) {
        containerView.isHidden = isShowSkeleton
    }
}

extension TagItemView {
    enum Style {
        case line(borderColor: UIColor, textColor: UIColor)
        case fill(fillColor: UIColor, textColor: UIColor)
        
        init(mainColor: UIColor, isFill: Bool) {
            switch isFill {
            case true:
                self = .fill(fillColor: mainColor, textColor: .white)
                
            case false:
                self = .line(borderColor: mainColor, textColor: mainColor)
            }
        }
        
        var borderColor: UIColor {
            switch self {
            case .line(let borderColor, _):
                return borderColor
                
            default:
                return .clear
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .line(_, let textColor):
                return textColor
                
            case .fill(_, let textColor):
                return textColor
            }
        }
        
        var fillColor: UIColor {
            switch self {
            case .line:
                return .clear
                
            case .fill(let fillColor, _):
                return fillColor
            }
        }
    }
}

extension TagItemView {
    static func roomNumber() -> TagItemView {
        return TagItemView(style: TagItemView.Style(mainColor: .gray700, isFill: false), marginHorizontal: 6).then {
            $0.isSkeletonable = true
            $0.text = "          " // Skeleton 영역 잡기 위해
            $0.flex.height(24)
        }
    }
    
    static func owner() -> TagItemView {
        return TagItemView(style: .init(mainColor: .red300, isFill: false)).then {
            $0.text = "방주인"
            $0.flex.height(24)
        }
    }
    
    static func plus() -> TagItemView {
        return  TagItemView(style: .init(mainColor: .violet300, isFill: false)).then {
            $0.text = "플러스"
            $0.flex.height(24)
        }
    }
    
    static func direct() -> TagItemView {
        return TagItemView(style: .init(mainColor: .green300, isFill: false)).then {
            $0.text = "직거래"
            $0.flex.height(24)
        }
    }
    
    static func naver() -> TagItemView {
        return TagItemView(style: TagItemView.Style(mainColor: .blue500, isFill: false), marginHorizontal: 6).then {
            $0.flex.height(24)
        }
    }
    
    static func plusButton() -> UIButton {
        let tagView = plus().then {
            $0.isUserInteractionEnabled = false
        }
        
        let button = UIButton(type: .custom)
        button.flex.addItem(tagView)
        return button
    }
}
