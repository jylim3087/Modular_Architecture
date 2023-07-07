//
//  ST3GalleryInteractor.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 8. 7..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit

public class ST3GalleryInteractor: UIPercentDrivenInteractiveTransition {
    var interacting = false
    
    weak var viewController : UIViewController? {
        didSet {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ST3GalleryInteractor.handlePan(_:)))
            self.viewController?.view.addGestureRecognizer(panGesture)
        }
    }
    
    public override var completionSpeed: CGFloat {
        get {
            return max(CGFloat(0.5), 1 - self.percentComplete)
        } set {
            self.completionSpeed = newValue
        }
    }
    
    @objc func handlePan(_ panGesture: UIPanGestureRecognizer) {
        guard let viewController = self.viewController else { return }
        let transition = panGesture.translation(in: nil)
        let progress = abs(transition.y / viewController.view.bounds.height)
        switch panGesture.state {
        case .began:
            self.interacting = true
            viewController.dismiss(animated: true)
        case .changed:
            if self.interacting { self.update(progress) }
        default:
            if self.interacting {
                if progress + panGesture.velocity(in: nil).y / viewController.view.bounds.height > 0.3 {
                    self.finish()
                } else {
                    self.cancel()
                }
                self.interacting = false
            }
        }
    }
}
