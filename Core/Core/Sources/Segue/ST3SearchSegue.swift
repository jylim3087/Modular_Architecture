//
//  ST3SearchSegue.swift
//  DabangSwift
//
//  Created by R.I.H on 09/05/2019.
//  Copyright © 2019 young-soo park. All rights reserved.
//

import UIKit

class ST3SearchSegue: NSObject {
    private static var shared  = ST3SearchSegue()
    private var isPresenting   = false
    
    static func show(_ viewControllerToPresent: UIViewController, on parentViewController: UIViewController) {
        viewControllerToPresent.modalPresentationStyle = .overFullScreen
        viewControllerToPresent.transitioningDelegate = shared
        parentViewController.present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    private func animatePresent(transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        toView.alpha = 0
        transitionContext.containerView.addSubview(toView)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            toView.alpha = 1.0
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
    
    fileprivate func animateDismiss(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        fromView.endEditing(false)
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            fromView.alpha = 0
        }, completion: { (finished) in
            fromView.transform = CGAffineTransform(translationX: 0.0, y: transitionContext.containerView.bounds.height)
            transitionContext.completeTransition(finished)
        })
    }
}

extension ST3SearchSegue: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }

}

extension ST3SearchSegue: UIViewControllerAnimatedTransitioning {
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

class ST3SearchViewSegue : UIStoryboardSegue {
    override func perform() {
        ST3SearchSegue.show(destination, on: source)
    }
}
