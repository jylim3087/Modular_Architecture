//
//  BottomSheetNavigationBar.swift
//  DabangSwift
//
//  Created by 조동현 on 2022/03/11.
//

import UIKit
import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

public class BottomSheetNavigationBar: UIView {
    
    // MARK: - UI
    
    private let contentView = UIView()
    
    private let leftView = UIView()
    
    private let rightView = UIView()
    
    private let backButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ic_24_app_bar_back_gray900"), for: .normal)
    }
    
    private let titleLabel = Body2_Bold().then {
        $0.textAlignment = .center
    }
    
    private let bottomLine = UIView()
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    
    private weak var nav: BottomSheetNavigationController?
    
    var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.flex.markDirty()
            setNeedsLayout()
        }
    }
    
    var hiddenBackButton: Bool = false {
        didSet {
            backButton.flex.isHidden(hiddenBackButton)
        }
    }
    
    var hiddenBottomLine: Bool = true {
        didSet {
            bottomLine.isHidden = hiddenBottomLine
        }
    }
    
    var leftViews: [UIView] = [] {
        didSet {
            setLeftViews()
        }
    }
    
    var rightViews: [UIView] = [] {
        didSet {
            setRightViews()
        }
    }
    
    convenience init(nav: BottomSheetNavigationController?) {
        self.init()
        self.nav = nav
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initComponent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initComponent()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    private func initComponent() {
        initLayout()
        bind()
    }
    
    private func bind() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.nav?.popView()
            })
            .disposed(by: disposeBag)
    }
}

extension BottomSheetNavigationBar {
    private func initLayout() {
        addSubview(contentView)
        
        contentView.flex.height(58).define { flex in
            flex.addItem().direction(.row).paddingHorizontal(20).justifyContent(.center).alignItems(.center).grow(1).define { flex in
                flex.addItem(titleLabel).grow(1).shrink(1)
                flex.addItem().position(.absolute).height(100%).left(20).direction(.row).alignItems(.center).define { flex in
                    flex.addItem(backButton).size(24).marginRight(4)
                    flex.addItem(leftView).direction(.row).alignItems(.center)
                }
                flex.addItem(rightView).position(.absolute).height(100%).right(20).direction(.rowReverse).alignItems(.center)
            }
            flex.addItem(bottomLine).height(1).position(.absolute).bottom(0).left(0).right(0).backgroundColor(.gray300).isHidden(true)
        }
    }
    
    private func setLeftViews() {
        leftView.subviews.forEach { $0.removeFromSuperview() }
        
        leftView.flex.define { flex in
            leftViews.forEach { view in
                flex.addItem(view).marginRight(4)
            }
        }
    }
    
    private func setRightViews() {
        rightView.subviews.forEach { $0.removeFromSuperview() }
        
        rightView.flex.define { flex in
            rightViews.forEach { view in
                flex.addItem(view).marginLeft(4)
            }
        }
    }
}
