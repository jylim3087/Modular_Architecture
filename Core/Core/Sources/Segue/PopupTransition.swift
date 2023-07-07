//
//  PopupTransition.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2020/11/20.
//  Copyright © 2020 young-soo park. All rights reserved.
//

import UIKit

final class PopupTransition: NSObject {
    static var shared = PopupTransition()
    private var backgroundView = UIView()
    private var isPresenting = false
    
    private func animatePresent(transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        transitionContext.containerView.addSubview(toView)
        toView.transform = CGAffineTransform(translationX: 0.0, y: transitionContext.containerView.bounds.height)
        backgroundView.frame = transitionContext.containerView.bounds
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.7
        transitionContext.containerView.insertSubview(backgroundView, at: 0)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            toView.transform = CGAffineTransform.identity
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
    
    fileprivate func animateDismiss(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            fromView.transform = CGAffineTransform(translationX: 0.0, y: transitionContext.containerView.bounds.height)
            self.backgroundView.alpha = 0.0
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension PopupTransition: UIViewControllerTransitioningDelegate {
    
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning

extension PopupTransition: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresent(transitionContext: transitionContext)
        } else {
            animateDismiss(transitionContext: transitionContext)
        }
    }
}
