//
//  ChipComponent.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/23.
//

import UIKit
import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public class ChipComponent: UIView, ChipComponentable {
    
    // MARK: - UI
    
    private let contentView = UIView().then {
        $0.layer.cornerRadius = 4
    }
    
    private let textLabel = Caption1_Bold()
    
    private let button = UIButton(type: .custom)
    
    // MARK: - ChipComponentable
    
    public var text: String? {
        didSet {
            textLabel.text = text
            textLabel.flex.markDirty()
            setNeedsLayout()
        }
    }
    
    public var deleteAction = PublishSubject<ChipComponentable>()
    
    // MARK: - DeletedChipSupportable
    
    private lazy var isDeleted: Bool = {
        (self as? DeletedChipSupportable) != nil
    }()
    
    // MARK: - ChipStyleSupportable
    
    private lazy var textColor: UIColor = {
        guard let style = self as? ChipStyleSupportable else { return .gray700 }
        return style.textColor
    }()
    
    private lazy var chipColor: UIColor = {
        guard let style = self as? ChipStyleSupportable else { return .gray200 }
        return style.chipColor
    }()
    
    private lazy var chipBorderColor: UIColor = {
        guard let style = self as? ChipStyleSupportable else { return .clear }
        return style.chipBorderColor
    }()
    
    private lazy var deleteImage: UIImage? = {
        guard let style = self as? ChipStyleSupportable else { return UIImage(named: "ic_16_close_gray700") }
        return style.deleteImage
    }()
    
    // MARK: - Property
    
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
        initLayout()
        setStyle()
        bind()
    }
    
    private func bind() {
        button.rx.tap
            .compactMap { [weak self] in self }
            .bind(to: deleteAction)
            .disposed(by: disposeBag)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        contentView.pin.all()

        contentView.flex.layout(mode: .adjustWidth)
    }
}

extension ChipComponent {
    private func initLayout() {
        addSubview(contentView)
        
        contentView.flex.direction(.row).paddingVertical(4).paddingHorizontal(8).minHeight(28).alignItems(.center).define { flex in
            flex.addItem(textLabel)
            flex.addItem(button).size(16).marginLeft(4).isHidden(true)
        }
    }
    
    private func setStyle() {
        contentView.backgroundColor = chipColor
        textLabel.textColor = textColor
        
        contentView.layer.borderColor = chipBorderColor.cgColor
        contentView.layer.borderWidth = 1
        
        button.setImage(deleteImage, for: .normal)
        button.flex.isHidden(!isDeleted)
    }
}

extension Reactive where Base: ChipComponentable {
    public var text: Binder<String?> {
        return Binder(base) { (component, text) in
            component.text = text
        }
    }
}
