//
//  ST3GalleryDismissAnimator.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 8. 7..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit

public class ST3GalleryDismissAnimator: NSObject {}

extension ST3GalleryDismissAnimator : UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        let containerView = transitionContext.containerView

        containerView.addSubview(fromView)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            fromVC.view.alpha = 0.0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
