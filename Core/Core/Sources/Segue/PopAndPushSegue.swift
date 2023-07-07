//
//  PopAndPushSegue.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 2. 7..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit

class FlipRightSegue: UIStoryboardSegue {
    
    override func perform() {
        guard let sourceView  = self.source.view        else { return }
        guard let destView    = self.destination.view   else { return }
        
        UIView.transition(from: sourceView, to: destView, duration: 0.5, options: .transitionFlipFromRight) { (_) in
            let source = self.source
            if let navi = source.navigationController {
                navi.popViewController(animated: false)
                navi.pushViewController(self.destination, animated: false)
            } else {
                self.source.present(self.destination, animated: false, completion: nil)
            }
        }
        
    }
}

class FlipLeftSegue: UIStoryboardSegue {
    
    override func perform() {
        guard let sourceView  = self.source.view        else { return }
        guard let destView    = self.destination.view   else { return }
        
        UIView.transition(from: sourceView, to: destView, duration: 0.5, options: .transitionFlipFromLeft) { (_) in
            let source = self.source
            if let navi = source.navigationController {
                navi.popViewController(animated: false)
                navi.pushViewController(self.destination, animated: false)
            } else {
                self.source.present(self.destination, animated: false, completion: nil)
            }
        }
        
    }
}

class ReplacePushSegue: UIStoryboardSegue {
    
    override func perform() {
        
        guard let sourceView   = self.source.view else { return }
        guard let destView     = self.destination.view else { return }
        guard let snapshotView = UIApplication.shared.delegate?.window??.snapshotImageView() else { return }
        
        guard let window = sourceView.window else { return }
        if let navi = source.navigationController {
            navi.popViewController(animated: false)
            navi.pushViewController(self.destination, animated: false)
            
            if window.subviews.count > 0 {
                let dimView = UIView(frame: snapshotView.bounds)
                dimView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
                snapshotView.addSubview(dimView)
                
                window.insertSubview(snapshotView, at: window.subviews.count - 1)
                
                // 그림자
                destView.layer.masksToBounds = false
                destView.layer.shadowOffset = CGSize(width: -3, height: 0)
                destView.layer.shadowRadius = 3
                destView.layer.shadowColor = UIColor.lightGray.cgColor
                destView.layer.shadowOpacity = 0.3
                
                UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    snapshotView.frame.origin.x = -snapshotView.bounds.size.width / 3.0
                    
                }, completion: nil)
                
                destView.frame.origin.x = snapshotView.bounds.size.width
                UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    destView.frame.origin.x = 0
                }, completion: { (_) in
                    snapshotView.removeFromSuperview()
                    destView.layer.shadowOffset = CGSize.zero
                    destView.layer.shadowRadius = 0
                })
            }
            
        } else {
            self.source.present(self.destination, animated: true, completion: nil)
        }
    }
}
