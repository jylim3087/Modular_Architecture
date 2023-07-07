//
//  TapComponent.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/15.
//

import UIKit
import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public class TapComponent: UIView, TapComponentable {
    
    // MARK: - UI
    
    private var topView = UIView()
    
    private var topLabel = Body3_Bold()
    
    private var topMarkView = UIView().then {
        $0.backgroundColor = .red500
        $0.layer.cornerRadius = 2
    }
    
    private var titleLabel = Body2_Bold()
    
    private var subLabel = Body2_Bold().then {
        $0.textColor = .blue500
        $0.isHidden = true
    }
    
    private var button = UIButton(type: .custom)
    
    // MARK: - TapComponentable
    
    public var isSelected: Bool = false {
        didSet {
            setStyle()
        }
    }
    
    public var isEnabled: Bool = true {
        didSet {
            setStyle()
            button.isEnabled = isEnabled
        }
    }
    
    public var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.flex.markDirty()
        }
    }
    
    public var tap = PublishSubject<TapComponentable>()
    
    // MARK: - TapSubStringSupportable
    
    public var subString: String? {
        didSet {
            hiddenSubString = subString == nil
            
            subLabel.text = subString
            subLabel.flex.markDirty()
        }
    }
    
    public var subStringColor: UIColor? = .blue500 {
        didSet {
            setStyle()
        }
    }
    
    // MARK: - TapTopStringSupportable
    
    public var topString: String? {
        didSet {
            topView.flex.isHidden(topString == nil)
            
            topLabel.text = topString
            topLabel.flex.markDirty()
        }
    }
    
    public var showTopMark: Bool = false {
        didSet {
            topMarkView.flex.isHidden(!showTopMark)
            self.setNeedsLayout()
        }
    }
    
    // MARK: - TapStyleSuppotable
    
    private lazy var alignItems: Flex.AlignItems = {
        guard let style = self as? TapStyleSuppotable else { return .center }
        return style.aligeItems
    }()
    
    private lazy var paddingBottom: CGFloat = {
        guard let style = self as? TapStyleSuppotable else { return 0 }
        return style.paddingBottom
    }()
    
    private lazy var enableColor: UIColor = {
        guard let style = self as? TapStyleSuppotable else { return .clear }
        return style.enableColor
    }()
    
    private lazy var disableColor: UIColor = {
        guard let style = self as? TapStyleSuppotable else { return .gray400 }
        return style.disableColor
    }()
    
    private lazy var selectedColor: UIColor = {
        guard let style = self as? TapStyleSuppotable else { return .gray900 }
        return style.selectedColor
    }()
    
    private lazy var enableBorderColor: UIColor = {
        guard let style = self as? TapStyleSuppotable else { return .clear }
        return style.enableBorderColor
    }()
    
    private lazy var disableBorderColor: UIColor = {
        guard let style = self as? TapStyleSuppotable else { return .clear }
        return style.disableBorderColor
    }()
    
    private lazy var selectedBorderColor: UIColor = {
        guard let style = self as? TapStyleSuppotable else { return .clear }
        return style.selectedBorderColor
    }()
    
    private lazy var enableTitleColor: UIColor = {
        guard let style = self as? TapStyleSuppotable else { return .gray900 }
        return style.enableTitleColor
    }()
    
    private lazy var disableTitleColor: UIColor = {
        guard let style = self as? TapStyleSuppotable else { return .gray400 }
        return style.disableTitleColor
    }()
    
    private lazy var selectedTitleColor: UIColor = {
        guard let style = self as? TapStyleSuppotable else { return .clear }
        return style.selectedTitleColor
    }()
    
    private lazy var radius: CGFloat? = {
        guard let style = self as? TapStyleSuppotable else { return nil }
        return style.radius
    }()
    
    private lazy var paddingTop: CGFloat = {
        guard let style = self as? TapStyleSuppotable else { return 0 }
        return style.paddingTop
    }()
    
    private lazy var paddingRight: CGFloat = {
        guard let style = self as? TapStyleSuppotable else { return 0 }
        return style.paddingRight
    }()
    
    private lazy var paddingLeft: CGFloat = {
        guard let style = self as? TapStyleSuppotable else { return 0 }
        return style.paddingLeft
    }()
    
    private lazy var enableFont: UIFont? = {
        guard let style = self as? TapStyleSuppotable else { return nil }
        return style.enableFont
    }()
    
    private lazy var selectedFont: UIFont? = {
        guard let style = self as? TapStyleSuppotable else { return nil }
        return style.selectedFont
    }()
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    
    private var hiddenSubString: Bool = true {
        didSet {
            subLabel.flex.isIncludedInLayout(!hiddenSubString)
            subLabel.isHidden = hiddenSubString
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initComponent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initComponent()
    }
    
    private func initComponent() {
        borderWidth = 1
        
        initLayout()
        setStyle()
        bind()
    }
    
    private func bind() {
        button.rx.tap
            .compactMap { [weak self] _ in self }
            .bind(to: tap)
            .disposed(by: disposeBag)
    }
}

extension TapComponent {
    private func initLayout() {
        
        flex.direction(.row).justifyContent(.center).alignItems(alignItems).paddingBottom(paddingBottom).paddingTop(paddingTop).paddingLeft(paddingLeft).paddingRight(paddingRight).define { flex in
            flex.addItem().define { flex in
                flex.addItem(topView).direction(.row).alignItems(.start).isIncludedInLayout(false).define { flex in
                    flex.addItem(topLabel)
                    flex.addItem(topMarkView).width(4).height(4).isHidden(!showTopMark)
                }
                
                flex.addItem().direction(.row).define { flex in
                    flex.addItem(titleLabel)
                    flex.addItem(subLabel).marginLeft(4).isIncludedInLayout(false)
                }
            }
            flex.addItem(button).position(.absolute).all(0)
        }
        
        flex.layout()
    }
    
    private func setStyle() {
        
        if let radius = radius {
            self.layer.cornerRadius = radius
        }
        
        if isEnabled {
            
            if isSelected {
                if let selectedFont = selectedFont {
                    topLabel.font = selectedFont
                    titleLabel.font = selectedFont
                    subLabel.font = selectedFont
                }
                else {
                    topLabel.font = .body3_bold
                    titleLabel.font = .body2_bold
                    subLabel.font = .body2_bold
                }
            }
            else {
                if let enableFont = enableFont {
                    topLabel.font = enableFont
                    titleLabel.font = enableFont
                    subLabel.font = enableFont
                }
                else {
                    topLabel.font = .body3_regular
                    titleLabel.font = .body2_regular
                    subLabel.font = .body2_regular
                }
            }

            topLabel.textColor = isSelected ? selectedTitleColor : enableTitleColor
            titleLabel.textColor = isSelected ? selectedTitleColor : enableTitleColor
            subLabel.textColor = subStringColor
            
            borderColor = isSelected ? selectedBorderColor : enableBorderColor
            backgroundColor = isSelected ? selectedColor : enableColor
        } else {
            if let enableFont = enableFont {
                topLabel.font = enableFont
                titleLabel.font = enableFont
                subLabel.font = enableFont
            }
            else {
                topLabel.font = .body3_regular
                titleLabel.font = .body2_regular
                subLabel.font = .body2_regular
            }
            
            topLabel.textColor = disableTitleColor
            titleLabel.textColor = disableTitleColor
            subLabel.textColor = disableTitleColor
            
            borderColor = disableBorderColor
            backgroundColor = disableColor
        }
        
        titleLabel.flex.markDirty()
        subLabel.flex.markDirty()
        setNeedsLayout()
    }
}
