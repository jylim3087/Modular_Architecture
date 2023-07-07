//
//  DropdownProtocol.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/20.
//

import UIKit
import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public protocol DropdownComponentable {
    var isRequired: Bool { get }
    var hasTitle: Bool { get }
}

extension DropdownComponentable {
    public var isRequired: Bool { return false }
    public var hasTitle: Bool { return false }
}

public class DropdownComponent: UIView {
    
    fileprivate enum Status {
        case enabled
        case disabled
        case error
        case focused
    }
    
    // MARK: - UI
    
    private let titleView = UIView().then {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    private let titleLabel = Body3_Bold()
    
    private let requiredLabel = Body3_Bold().then {
        $0.text = "*"
        $0.textColor = .blue500
    }
    
    private let bodyView = UIView().then {
        $0.layer.cornerRadius = 2
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray300.cgColor
        
        $0.backgroundColor = .clear
    }
    
    private let textLabel = Body3_Regular()
    
    private let rightWrapView = UIView()
    
    private let arrowImageView = UIImageView().then {
        $0.image = UIImage(named: "ic24ArrowDownGray500")
    }
    
    private let button = UIButton(type: .custom)
    
    // MARK: - Property
    
    private var status: Status = .enabled
    
    private var disposeBag = DisposeBag()
    
    private lazy var isRequired: Bool = {
        guard let dropdown = self as? DropdownComponentable else { return false }
        return dropdown.isRequired
    }()
    
    private lazy var hasTitle: Bool  = {
        guard let dropdown = self as? DropdownComponentable else { return false }
        return dropdown.hasTitle
    }()
    
    @IBInspectable public var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.flex.markDirty()
            
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var placeHolder: String? {
        didSet {
            setTextStyle()
        }
    }
    
    @IBInspectable public var text: String? {
        didSet {
            setTextStyle()
        }
    }
    
    @IBInspectable public var isEnabled: Bool = true {
        didSet {
            if isEnabled == false {
                status = .disabled
            } else {
                status = isError ? .error : .enabled
            }
            
            setStyle()
        }
    }
    
    @IBInspectable public var isError: Bool = false {
        didSet {
            guard isEnabled else { return }
            
            status = .error
            setStyle()
        }
    }
    
    @IBInspectable public var isFocus: Bool = false {
        didSet {
            if isFocus == false {
                status = isError ? .error : (isEnabled ? .enabled : .disabled)
            } else {
                status = isError ? .error : (isEnabled ? .focused : .disabled)
            }
            
            setStyle()
        }
    }
    
    public var tap = PublishSubject<Void>()
    
    public var rightView: UIView? {
        didSet {
            setRightView()
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
        initLayout()
        initStyle()
        setStyle()
        setTextStyle()
        bind()
    }
    
    private func bind() {
        button.rx.tap
            .bind(to: tap)
            .disposed(by: disposeBag)
    }
}

extension DropdownComponent {
    private func initLayout() {
        flex.addItem(titleView).direction(.row).marginBottom(8).define { flex in
            flex.addItem(titleLabel)
            flex.addItem(requiredLabel).marginLeft(4)
        }
        
        flex.addItem(bodyView).direction(.row).alignItems(.center).define { flex in
            flex.addItem(textLabel).grow(1).shrink(1).marginLeft(16).marginTop(10).marginBottom(10)
            flex.addItem(rightWrapView).marginLeft(8).define { flex in
                flex.addItem(arrowImageView).width(24).height(24).marginRight(10)
            }
        }
        
        flex.addItem(button).position(.absolute).all(0)
        
        flex.layout()
    }
    
    private func initStyle() {
        titleView.isHidden = !hasTitle
        titleView.flex.isIncludedInLayout(hasTitle)
        
        requiredLabel.isHidden = !isRequired
        requiredLabel.flex.isIncludedInLayout(isRequired)
    }
    
    private func setStyle() {
        button.isEnabled = status != .disabled
        
        bodyView.backgroundColor = status.backgroundColor
        bodyView.layer.borderColor = status.borderColor.cgColor
        setTextStyle()
        
        let image = isFocus ? "ic_24_arrow_up_gray900" : "ic24ArrowDownGray500"
        arrowImageView.image = UIImage(named: image)
    }
    
    private func setTextStyle() {
        if let text = text {
            textLabel.text = text
            textLabel.textColor = status.textColor
        } else {
            textLabel.text = placeHolder
            textLabel.textColor = .gray600
        }
        
        textLabel.flex.markDirty()
        setNeedsLayout()
    }
    
    private func setRightView() {
        rightWrapView.subviews.forEach { $0.removeFromSuperview() }
        
        if let rightView = rightView {
            rightWrapView.flex.addItem(rightView)
        } else {
            rightWrapView.flex.addItem(arrowImageView).width(24).height(24).marginRight(10)
        }
        
        setNeedsLayout()
    }
}

extension DropdownComponent.Status {
    public var textColor: UIColor {
        switch self {
        case .enabled, .focused, .error: return .gray900
        case .disabled: return .gray500
        }
    }
    
    public var backgroundColor: UIColor {
        switch self {
        case .enabled, .focused, .error: return .clear
        case .disabled: return .gray50
        }
    }
    
    public var borderColor: UIColor {
        switch self {
        case .enabled, .disabled: return .gray300
        case .error: return .red500
        case .focused: return .gray900
        }
    }
}
