//
//  BottomSheetNavigationController.swift
//  DabangSwift
//
//  Created by 조동현 on 2022/03/11.
//

import UIKit
import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

public class BottomSheetNavigationController: ModalTranslucenceViewController, BottomSheetNavigationSupportable {
    
    // MARK: - UI
    
    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = false
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.clipsToBounds = false
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .white0
        $0.clipsToBounds = false
    }
    
    // MARK: - Property
    
    public var sheetViews: [BottomSheetNavigationView] {
        return views.flatMap { $0.subviews.compactMap { $0 as? BottomSheetNavigationView } }
    }
    
    private var views: [UIView] = []
    
    private let width = UIScreen.main.bounds.width
    
    private var notchTop: CGFloat = {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        } else {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
        }
    }()
    
    private var notchBottom: CGFloat = {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        } else {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        }
    }()
    
    public var isHiddenHandler: Bool = false {
        didSet {
            disableGesture = isHiddenHandler
            let maxH = (view.frame.maxY - notchTop - 40) - (isBottomSafeArea ? notchBottom : 0)
            contentView.flex.direction(.row).maxHeight(maxH)
            
            update(animated: false)
        }
    }
    
    public var dismissHandler: (() -> ())?
    
    public override var dismissAction: (() -> Void) {
        { [weak self] in
            self?.dismissHandler?()
        }
    }
    public override var isBottomSafeArea: Bool { true }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
//        isBottomSafeArea = true
    }
    
    public override func loadView() {
        super.loadView()
        
        bodyView.flex.addItem(scrollView)
        
        scrollView.addSubview(contentView)
        
        let maxH = (view.frame.maxY - notchTop - 40) - 20 - (isBottomSafeArea ? notchBottom : 0)
        contentView.flex.direction(.row).maxHeight(maxH)
        contentView.pin.top().bottom().left()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BottomSheetNavigationController {
    @discardableResult
    public func pushView(_ view: BottomSheetNavigationViewComponentable, animated: Bool = true) -> BottomSheetNavigationController {
        let animated = views.count > 0 ? animated : false
        
        view.navigationController = self
        views.forEach { $0.flex.isIncludedInLayout(false)}
        
        let count = CGFloat(views.count)
        let x = width * count
        
        contentView.flex.width(width * (count + 1))
        contentView.flex.addItem(makeView(view)).width(width).left(x)
        contentView.flex.layout(mode: .adjustHeight)
        
        if view.fullHeight {
            let maxH = (self.view.frame.maxY - notchTop - 40) - (isHiddenHandler ? 0 : 20)  - (isBottomSafeArea ? notchBottom : 0)
            
            if contentView.frame.height < maxH {
                contentView.flex.height(maxH)
            }
        }
        
        scrollView.pin.height(contentView.frame.height)
        scrollView.contentSize = contentView.bounds.size
        
        update(x, animated: animated)
        
        return self
    }
    
    public func popView(animated: Bool = true) {
        guard views.count > 1 else { return }
        
        views.forEach { $0.flex.isIncludedInLayout(false) }
        
        let view = views.removeLast()
        let count = CGFloat(views.count)
        
        views.last?.flex.isIncludedInLayout(true)
        
        contentView.flex.width(width * count).layout(mode: .adjustHeight)
        
        if let view = view as? BottomSheetNavigationViewComponentable, view.fullHeight {
            let maxH = (self.view.frame.maxY - notchTop - 40) - (isHiddenHandler ? 0 : 20)  - (isBottomSafeArea ? notchBottom : 0)
            
            if contentView.frame.height < maxH {
                contentView.flex.height(maxH)
            }
        }
        
        scrollView.pin.height(contentView.frame.height)
        
        update(width * (count - 1), animated: animated) { [weak self] completion in
            guard let self = self else { return }
            
            self.scrollView.contentSize = self.contentView.bounds.size
            view.removeFromSuperview()
        }
    }
    
    public func update(animated: Bool = true) {
        update(scrollView.contentOffset.x, animated: animated)
    }
    
    public func show(_ vc: UIViewController? = nil) {
        if let vc = vc {
            vc.present(self, animated: false)
        } else if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            var presentedController = viewController
            while let presented = presentedController.presentedViewController,
                presentedController.presentedViewController?.isBeingDismissed == false {
                    presentedController = presented
            }
            
            presentedController.present(self, animated: false, completion: nil)
        }
    }
    
    private func update(_ x: CGFloat, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        if animated {
            animate(x, completion: completion)
        } else {
            scrollView.contentOffset = CGPoint(x: x, y: 0)
            updateLayout()
            
            completion?(true)
        }
    }
    
    private func animate(_ x: CGFloat, completion: ((Bool) -> Void)? = nil) {
        scrollView.contentOffset = CGPoint(x: x, y: 0)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.updateLayout()
            
        }, completion: completion)
    }
    
    private func makeView(_ view: BottomSheetNavigationViewComponentable) -> UIView {
        let v = UIView()
        let nav = BottomSheetNavigationBar(nav: self)
        
        v.flex.define { flex in
            flex.addItem(nav)
            flex.addItem(view).shrink(1)
            
            if view.fullHeight {
                view.flex.grow(1)
            }
        }
        
        view.navigationBar = nav
        view.setNavigation(nav)
        
        views.append(v)
        
        return v
    }
}
