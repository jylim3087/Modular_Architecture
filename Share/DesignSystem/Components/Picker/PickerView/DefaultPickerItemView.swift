//
//  DefaultPickerItemView.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/28.
//

import UIKit
import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

final class DefaultPickerItemView: UIView, PickerItemComponentable {
    
    // MARK: - UI
    
    private let label = Body1_Regular().then {
        $0.textAlignment = .center
    }
    
    private let button = UIButton(type: .custom)
    
    // MARK: - Property
    
    var title: String? {
        didSet {
            label.text = title
            label.flex.markDirty()
            
            setNeedsLayout()
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            setStyle()
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            button.isEnabled = isEnabled
            setStyle()
        }
    }
    
    var textAlignment: NSTextAlignment = .center {
        didSet {
            label.textAlignment = textAlignment
            label.flex.markDirty()
            
            flex.layout(mode: .adjustWidth)
            flex.layout(mode: .adjustHeight)
        }
    }
    
    var tap = PublishSubject<Void>()
    
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
        bind()
        isSelected = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flex.layout(mode: .adjustWidth)
        flex.layout(mode: .adjustHeight)
    }
    
    private func initLayout() {
        flex.addItem().define {
            $0.addItem().paddingHorizontal(16).paddingVertical(4).define { flex in
                flex.addItem(label).grow(1).shrink(1)
            }
            $0.addItem(button).position(.absolute).all(0)
        }
    }
    
    private func bind() {
        button.rx.tap
            .filter { [weak self] _ in self?.isSelected == false }
            .bind(to: tap)
            .disposed(by: disposeBag)
    }
    
    private func setStyle() {
        label.font = isEnabled ? (isSelected ? .subtitle1_bold : .body1_regular) : .body1_regular
        label.textColor = isEnabled ? (isSelected ? .blue500 : .gray600) : .gray400
        label.flex.markDirty()
        
        flex.layout(mode: .adjustWidth)
        flex.layout(mode: .adjustHeight)
    }
}
