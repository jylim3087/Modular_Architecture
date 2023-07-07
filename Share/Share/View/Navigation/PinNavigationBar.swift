//
//  PinNavigationBar.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2021/05/11.
//

import UIKit
import FlexLayout
import RxSwift
import RxCocoa

public final class PinNavigationBar: UIView {
    enum DismissButtonType {
        case none
        case close
        case back
    }
    
    // MARK: UI
    
    fileprivate let safeAreaView = UIView()
    
    fileprivate let barView = UIView()
    
    let backButton = UIButton().then {
        $0.tintColor = .gray900
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        $0.isExclusiveTouch = true
    }
    
    private let titleLabel = Body2_Bold().then {
        $0.textAlignment = .center
    }
    
    private let titleButton = UIButton()
    
    private let rightSideView = UIView()
    
    private let leftStackView = UIView()

    private let rightStackView = UIView()
    
    fileprivate let divisionView = UIView().then {
        $0.backgroundColor = .gray300
        $0.isHidden = true
    }
    
    private var dummyView = UIView()
    
    private var rightDummyView = UIView()
    
    private var indicator = UIView().then {
        $0.backgroundColor = .blue500
    }
    
    // MARK: Property
    
    var dismissBtnType: DismissButtonType = .back {
        didSet {
            setDismissButton(dismissBtnType)
        }
    }
    
    private var isAnimating = false
    
    weak var delegate: ST3NavigationBarDelegate?
    
    public var title: String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.flex.markDirty()
            self.setNeedsLayout()
        }
    }
    
    public var isHiddenDivision: Bool {
        get { return divisionView.isHidden }
        set { divisionView.isHidden = newValue }
    }
    
    public var titleRightView: UIView? {
        set {
            self.rightSideView.subviews.forEach { $0.removeFromSuperview() }
            if let newValue = newValue {
                self.rightSideView.flex.isHidden(false)
                self.rightSideView.flex.addItem(newValue)
            } else {
                self.rightSideView.flex.isHidden(true)
            }
            
            self.setNeedsLayout()
        }
        get { return self.rightSideView.subviews.first }
    }
    
    public var titleButtonTap: Observable<Void> { titleButton.rx.tap.asObservable() }
    
    init(rightViews: [UIView] = [], dismissBtnType: DismissButtonType = .back) {
        super.init(frame: .zero)
        backgroundColor = .white0
        
        self.dismissBtnType = dismissBtnType
        setDismissButton(dismissBtnType)
        
        backButton.addTarget(self, action: #selector(actionTouchUpInsideBackNavigation), for: .touchUpInside)
        
        let window = UIApplication.shared.keyWindow ?? UIWindow()
        
        flex.define { flex in
            flex.addItem(safeAreaView).height(window.safeAreaInsets.top)
            flex.addItem(barView).direction(.row).marginHorizontal(20).height(50).define { flex in
                flex.addItem(leftStackView).direction(.row).define { flex in
                    flex.addItem(backButton).width(44)
                }
                flex.addItem().grow(1).justifyContent(.center).define { flex in
                    flex.addItem().direction(.row).justifyContent(.center).alignItems(.center).define { flex in
                        flex.addItem(titleLabel)
                        flex.addItem(rightSideView).marginLeft(4).direction(.row).alignItems(.center).isHidden(true)
                        flex.addItem(titleButton).position(.absolute).all(0)
                    }
                }
                flex.addItem(rightStackView).justifyContent(.start).alignItems(.center).direction(.rowReverse).define { flex in
                    rightViews.forEach { view in
                        flex.addItem(view).marginLeft(8)
                    }
                }
            }
            flex.addItem(divisionView).position(.absolute).horizontally(0).bottom(0).height(1)
            flex.addItem(indicator).position(.absolute).left(0).bottom(0).size(CGSize(width: 0, height: 2))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let basisWidth: CGFloat = max(52, getItemViewsWidth(rightStackView))
        
        leftStackView.flex.width(basisWidth)
        rightStackView.flex.width(basisWidth)
        
        flex.layout(mode: .adjustHeight)
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return flex.intrinsicSize
    }
    
    @objc func actionTouchUpInsideBackNavigation() {
        guard let viewController = self.viewController() else { return }
        viewController.view.endEditing(true)
        
        if self.delegate?.navigationBarShouldBackNavigation() ?? true {
            if let navigationController = viewController.navigationController, navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: true)
            } else {
                viewController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func setDismissButton(_ type: DismissButtonType) {
        let image: UIImage?
        
        switch type {
        case .none:
            backButton.isHidden = true
            return
            
        case .close:
            image = UIImage(named: "ic_24_app_bar_close_gray900")
            
        case .back:
            image = UIImage(named: "ic_24_app_bar_back_gray900")
        }
        
        backButton.isHidden = type == .none
        
        backButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    private func getItemViewsWidth(_ superview: UIView) -> CGFloat {
        return superview.subviews.reduce(0) { result, itemView in
            guard itemView.isHidden == false && itemView.yoga.isIncludedInLayout == true else { return result }
            
            let width = itemView.yoga.width.value.isNaN == false ? CGFloat(itemView.yoga.width.value)
                                                            : (itemView.yoga.flexBasis.value.isNaN == false ? CGFloat(itemView.yoga.flexBasis.value) : itemView.intrinsicContentSize.width)
            return result + width + 8
        }
    }
}

private let kNormalButtonTintColor = UIColor.gray900

extension PinNavigationBar {
    @discardableResult
    func updateNavigationBar(offset: CGPoint, limitHeight: CGFloat) -> CGFloat {
        let height = limitHeight - bounds.height
        let alpha = CGFloat.minimum(offset.y / height, 1)
        let blendColor = kNormalButtonTintColor.blendColor(targetColor: UIColor.white0, ratio: alpha)
        
        titleLabel.alpha = alpha
        divisionView.alpha = alpha
        titleLabel.textColor = blendColor
        backgroundColor = backgroundColor?.withAlphaComponent(alpha)
        
        setButtonTintColor(parent: leftStackView, color: blendColor)
        setButtonTintColor(parent: rightStackView, color: blendColor)
        
        return alpha
    }
    
    public func setButtonTintColor(parent: UIView, color: UIColor) {
        for subView in parent.subviews where subView is UIButton {
            subView.tintColor = color
        }
    }
    
    public func startProgressAnimation() {
        if isAnimating { return }
        isAnimating = true
    
        animationConfig()
    }
    
    public func stopProgressAnimation() {
        if !isAnimating { return }
        isAnimating = false
    }
    
    public func configureProgressAnimation(_ isOn: Bool) {
        isOn ? startProgressAnimation() : stopProgressAnimation()
    }
    
    private func animationConfig() {
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.indicator.frame = CGRect(origin: self.indicator.frame.origin,
                                              size: CGSize(width: self.frame.width * 0.7, height: 2))
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                let origin = CGPoint(x: self.frame.width, y: self.indicator.frame.origin.y)
                self.indicator.frame = CGRect(origin: origin,
                                              size: CGSize(width: 0, height: 2))
            }
        }, completion: { (finished) in
            self.indicator.frame = CGRect(x: 0, y: self.indicator.frame.origin.y, width: 0, height: 2)
            if finished && self.isAnimating {
                self.animationConfig()
            }
        })
    }
}
