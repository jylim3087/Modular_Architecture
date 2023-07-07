//
//  BlurPopupSegue.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 11. 24..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit

class ST3BlurPopup: NSObject {
    
    static var shared   : ST3BlurPopup          = ST3BlurPopup()
    private var backgroundView  : UIView                = UIView()
    private var isPresenting    : Bool                  = false
    
    static func show(_ viewControllerToPresent: UIViewController, on parentViewController: UIViewController) {
        viewControllerToPresent.modalPresentationStyle = .overFullScreen
        viewControllerToPresent.transitioningDelegate = shared
        parentViewController.present(viewControllerToPresent, animated: true, completion: nil)
    }
    
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

extension ST3BlurPopup: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning

extension ST3BlurPopup: UIViewControllerAnimatedTransitioning {
    
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

class ST3BlurPopupSegue : UIStoryboardSegue {
    override func perform() {
        ST3BlurPopup.show(destination, on: source)
    }
}
