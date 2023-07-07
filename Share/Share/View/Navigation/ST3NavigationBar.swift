//
//  ST3NavigationBar.swift
//  DabangSwift
//
//  Created by Kim JungMoo on 2017. 11. 15..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

@objc protocol ST3NavigationBarDelegate: AnyObject {
    func navigationBarShouldBackNavigation() -> Bool
}

@IBDesignable
public class ST3NavigationBar: UIView {
    weak var stackView              : UIStackView?
    weak var rightTitleView         : UIView?

    weak var titleLabel             : UILabel?
    weak var backButton             : UIButton?
    weak var bottomDivider          : UIView?
    
    @IBOutlet public var ignoreRenderingModeButtons: [UIButton] = []

    @IBInspectable var backButtonImage: UIImage? {
        set { self.backButton?.setImage(newValue, for: .normal) }
        get { return self.backButton?.image(for: .normal) }
    }
    
    @IBInspectable var hidesBackButton: Bool {
        set { self.backButton?.isHidden = newValue }
        get { return self.backButton?.isHidden ?? false }
    }
    
    @IBInspectable var hidesBottomDivider: Bool {
        set { self.bottomDivider?.isHidden = newValue }
        get { return self.bottomDivider?.isHidden ?? false }
    }
    
    @IBInspectable var title: String? {
        set { self.titleLabel?.text = newValue }
        get { return self.titleLabel?.text }
    }
    
    @IBInspectable var titleColor: UIColor? {
        set { self.titleLabel?.textColor = newValue }
        get { return self.titleLabel?.textColor }
    }
    
    public var rightView: UIView? {
        set {
            self.rightTitleView?.subviews.forEach { $0.removeFromSuperview() }
            if let newValue = newValue {
                newValue.translatesAutoresizingMaskIntoConstraints = false
                self.rightTitleView?.addSubview(newValue)
                self.rightTitleView?.isHidden = false
                newValue.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            } else {
                self.rightTitleView?.isHidden = true
            }
        }
        get { return self.rightTitleView?.subviews.first }
    }
    
    public var isTitleViewHidden: Bool {
        set { self.stackView?.isHidden = newValue }
        get { return self.stackView?.isHidden ?? false }
    }
    
    public var isBottomDividerHidden: Bool {
        set { self.bottomDivider?.isHidden = newValue }
        get { return self.bottomDivider?.isHidden ?? false }
    }
    
    @IBOutlet weak var delegate: ST3NavigationBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSelf()
        self.initStackView()
        self.initBackButton()
        self.initBottomDivider()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSelf()
        self.initStackView()
        self.initBackButton()
        self.initBottomDivider()
    }
    
    public func initSelf() {
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func initStackView() {
        if self.stackView != nil { return }
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false
        self.addSubview(stackView)
        self.stackView = stackView
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black1
        titleLabel.textAlignment = .center
        titleLabel.minimumScaleFactor = 0.8
        self.stackView?.addArrangedSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let rightImageView = UIView()
        self.stackView?.addArrangedSubview(rightImageView)
        self.rightTitleView = rightImageView
        rightImageView.isHidden = true
    }
    
    public func initBackButton() {
        if self.backButton != nil { return }

        let backButton = UIButton(type: .custom)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "btnBackTitle"), for: .normal)
        
        backButton.addTarget(self, action: #selector(actionTouchUpInsideBackNavigation), for: .touchUpInside)
        
        self.addSubview(backButton)
        
        self.backButton = backButton
    }
    
    public func initBottomDivider() {
        if self.bottomDivider != nil { return }
        let bottomDivider = UIView()
        bottomDivider.translatesAutoresizingMaskIntoConstraints = false
        bottomDivider.backgroundColor = .grey3
        
        self.addSubview(bottomDivider)
        self.bottomDivider = bottomDivider
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.stackView?.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(bounds.width - 100)
        }

        self.backButton?.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 50, height: bounds.height))
        }
        
        self.bottomDivider?.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    @objc public func actionTouchUpInsideBackNavigation() {
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
}

extension Reactive where Base : ST3NavigationBar {
    public var title : Binder<String?> {
        return Binder(self.base) { bar, title in
            bar.title = title
        }
    }
    
    public var isProgressAnimating : Binder<Bool> {
        return Binder(self.base) { bar, isProgressAnimating in
            bar.isAnimating = isProgressAnimating
        }
    }
}
