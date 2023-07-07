//
//  BottomPopupSegue.swift
//  DabangSwift
//
//  Created by 조동현 on 2020/12/07.
//  Copyright © 2020 young-soo park. All rights reserved.
//
import UIKit
import SnapKit

protocol BottomPopupType {
    var bodyView: UIView { get }
}

final class ST3BottomPopup : NSObject {
    static var shared   : ST3BottomPopup    = ST3BottomPopup()
    private var isPresenting    = false
    
    func animatePresentationWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let superView = transitionContext.view(forKey: .to) else { return }
        guard let filterPopup = transitionContext.viewController(forKey: .to) as? BottomPopupType else { return }
        transitionContext.containerView.addSubview(superView)
        let _ = superView.snapshot
        
        superView.alpha = 0.3
        filterPopup.bodyView.snp.remakeConstraints {
            $0.top.greaterThanOrEqualTo(100)
            $0.leading.trailing.equalTo(0)
            $0.bottom.equalTo(0)
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: .curveEaseInOut,
            animations: {
                superView.alpha = 1.0
                superView.layoutIfNeeded()
            },
            completion: { (finished) in
                transitionContext.completeTransition(finished)
            }
        )
    }
    
    func animateDismissalWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let superView = transitionContext.view(forKey: .from) else { return }
        guard let filterPopup = transitionContext.viewController(forKey: .from) as? BottomPopupType else { return }
        let bodyView = filterPopup.bodyView
        
        bodyView.snp.remakeConstraints {
            $0.top.equalTo(superView.snp.bottom)
            $0.leading.trailing.equalTo(0)
            $0.bottom.equalTo(bodyView.frame.height)
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: .curveEaseInOut,
            animations: {
                superView.alpha = 0.0
                superView.layoutIfNeeded()
            },
            completion: { (finished) in
                transitionContext.completeTransition(finished)
            }
        )
    }
}

extension ST3BottomPopup : UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController,presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}

extension ST3BottomPopup : UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        } else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }
}

final class ST3PinBottomPopup : NSObject {
    static var shared   : ST3PinBottomPopup    = ST3PinBottomPopup()
    private var isPresenting    = false
    
    func animatePresentationWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let superView = transitionContext.view(forKey: .to) else { return }
        guard let filterPopup = transitionContext.viewController(forKey: .to) as? BottomPopupType else { return }
        transitionContext.containerView.addSubview(superView)
        let _ = superView.snapshot
        
        superView.alpha = 0.3
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: .curveEaseInOut,
            animations: {
                superView.alpha = 1.0
                filterPopup.bodyView.pin.bottom()
            },
            completion: { (finished) in
                transitionContext.completeTransition(finished)
            }
        )
    }
    
    func animateDismissalWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let superView = transitionContext.view(forKey: .from) else { return }
        guard let filterPopup = transitionContext.viewController(forKey: .from) as? BottomPopupType else { return }
        let bodyView = filterPopup.bodyView
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: .curveEaseInOut,
            animations: {
                superView.alpha = 0.0
                bodyView.pin.top(to: superView.edge.bottom)
            },
            completion: { (finished) in
                transitionContext.completeTransition(finished)
            }
        )
    }
}

extension ST3PinBottomPopup : UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController,presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}

extension ST3PinBottomPopup : UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        } else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }
}
