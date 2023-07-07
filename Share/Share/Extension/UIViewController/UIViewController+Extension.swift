//
//  UIViewController+utils.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 3. 6..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

// swiftlint:disable use_safePerformSegue
import UIKit
import RxSwift
import RxCocoa
import Toaster

extension UIViewController {
    var st3Navigationbar: ST3NavigationBar? {
        for view in self.view.subviews where view is ST3NavigationBar { return view as? ST3NavigationBar }
        return nil
    }
    
    static func topViewController(_ root:UIViewController? = nil) -> UIViewController? {
        let viewController = root ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navi = viewController as? UINavigationController, !navi.viewControllers.isEmpty {
            return self.topViewController(navi.viewControllers.last)
        } else if let tabBar = viewController as? UITabBarController, let selected = tabBar.selectedViewController {
            return self.topViewController(selected)
        } else if let presented = viewController?.presentedViewController {
            return self.topViewController(presented)
        }
        
        return viewController
    }
    
    static func topMostViewController(_ root:UIViewController? =
        UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let presented = root?.presentedViewController {
            return self.topMostViewController(presented)
        }
        return root
    }
    
    func canPerformSegue(identifier:String) -> Bool {
        let segues = self.value(forKey: "storyboardSegueTemplates") as? [NSObject]
        let filtered = segues?.filter({ $0.value(forKey: "identifier") as? String == identifier })
        guard let filterd = filtered else { return false }
        return filterd.count > 0
    }
    
    func safePerformSegue(withIdentifier identifier: String, sender: Any?) {
        if self.canPerformSegue(identifier: identifier) {
            self.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    func presentWithNavigation(_ controller: UIViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.isNavigationBarHidden = true
        
        self.present(navigationController, animated: true, completion: completion)
    }
    
    func findChildViewControllerFor<T: UIViewController>(_ type: T.Type) -> T? {
        for viewController in self.children where viewController is T { return viewController as? T }
        return nil
    }
    
    public static let presentFullScreenSwizzledMethod: Void = {
        let originalSelector = #selector(present(_:animated:completion:))
        let swizzledSelector = #selector(newPresent(_:animated:completion:))
        let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)
        
        if let origin = originalMethod, let swizzle = swizzledMethod {
            method_exchangeImplementations(origin, swizzle)
        }
    }()
    
    @objc func newPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
        }
        newPresent(viewControllerToPresent, animated: flag, completion: completion)
    }
}

extension UIViewController {
    static func deinitCheckSwizzledMethodByViewDidDisappear() {
        let originalSelector = #selector(viewDidDisappear(_:))
        let swizzledSelector = #selector(swizzledViewDidDisappear(_:))
        let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)
        
        if let origin = originalMethod, let swizzle = swizzledMethod {
            method_exchangeImplementations(origin, swizzle)
        }
    }
    
    @objc func swizzledViewDidDisappear(_ animated: Bool) {
        checkDeinit()
        
        swizzledViewDidDisappear(animated)
    }
    
    private func checkDeinit(delay: TimeInterval = 2.0) {
        let rootParentViewController = deinit_rootParentViewController
        
        if isMovingFromParent == true || rootParentViewController.isBeingDismissed == true {
            let type = type(of: self)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                if self != nil {
                    print("🙅🏼‍♀️🙅🏼‍♀️🙅🏼‍♀️🙅🏼‍♀️🙅🏼‍♀️ \(type) : deinit 되지 않음.")
                }
            }
        }
    }
    
    private var deinit_rootParentViewController: UIViewController {
        var root = self
        
        while let parent = root.parent {
            root = parent
        }
        
        return root
    }
}

extension Reactive where Base: UIViewController {
    var showToast: Binder<String?> {
        return Binder(base) { (_, text) in
            Toast(text: text).show()
        }
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) -> Binder<Void> {
        return Binder(base) { (vc, _) in
            if let nav = vc.navigationController {
                nav.popViewController(animated: animated)
            } else {
                vc.dismiss(animated: animated, completion: completion)
            }
        }
    }
    
    var dismiss: Binder<Void> {
        return Binder(base) { (vc, _) in
            if let nav = vc.navigationController {
                nav.popViewController(animated: true)
            } else {
                vc.dismiss(animated: true)
            }
        }
    }
}
extension UIViewController {
    func generateViewController( name: String, id: String? = nil) -> UIViewController? {
        let storybard = UIStoryboard(name: name, bundle: nil)
        
        if let id = id {
            return storybard.instantiateViewController(withIdentifier: id)
        }
        else {
            return storybard.instantiateInitialViewController()
        }
    }
}
