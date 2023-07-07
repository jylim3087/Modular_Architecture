//
//  BottomSheetNavigationView.swift
//  DabangSwift
//
//  Created by 조동현 on 2022/03/11.
//

import UIKit

public class BottomSheetNavigationView: UIView, BottomSheetNavigationSupportable, BottomSheetNavigationViewComponentable {
    
    // MARK: - BottomSheetNavigationSupportable
    
    public var isHiddenHandler: Bool {
        set {
            _isHiddenHandler = newValue
            navigationController?.isHiddenHandler = newValue
        }
        get {
            navigationController?.isHiddenHandler ?? _isHiddenHandler
        }
    }
    
    public var isBackgroundDismiss: Bool {
        set {
            _isBackgroundDismiss = newValue
            navigationController?.isBackgroundDismiss = newValue
        }
        get {
            navigationController?.isBackgroundDismiss ?? _isBackgroundDismiss
        }
    }
    
    var dismissHandler: (() -> ())? {
        set {
            _dismissHandler = newValue
            navigationController?.dismissHandler = newValue
        }
        get {
            navigationController?.dismissHandler ?? _dismissHandler
        }
    }
    
    public var fullHeight: Bool = false
    
    private var _isHiddenHandler = false
    private var _isBackgroundDismiss = true
    private var _dismissHandler: (() -> ())?
    
    // MARK: - BottomSheetNavigationViewComponentable
    
    weak public var navigationBar: BottomSheetNavigationBar?
    weak public var navigationController: BottomSheetNavigationController?
    
    public func present(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        let vc = BottomSheetNavigationController()
        vc.isHiddenHandler = _isHiddenHandler
        vc.isBackgroundDismiss = _isBackgroundDismiss
        vc.dismissHandler = _dismissHandler
        
        vc.pushView(self)
        
        viewController.present(vc, animated: false) {
            completion?()
        }
    }
    
    public func setNavigation(_ nav: BottomSheetNavigationBar) {}
    
    public func updateView(animated: Bool = true) {
        navigationController?.update(animated: animated)
    }
}

extension UIViewController {
    public func present(_ view: BottomSheetNavigationViewComponentable, completion: (() -> Void)? = nil) {
        guard let nav = self.presentedViewController as? BottomSheetNavigationController, nav.isBeingDismissed == false else {
            view.present(self, completion: completion)
            return
        }
        
        nav.pushView(view)
    }
}
