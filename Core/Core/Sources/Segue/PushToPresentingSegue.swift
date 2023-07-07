//
//  PushToPresentingSegue.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 2. 3..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit

class PushToPresentingSegue : UIStoryboardSegue {
    
    override func perform() {
        let source = self.source
        if let presentingViewController = source.presentingViewController {
            source.dismiss(animated: true, completion: nil)
            if let navi = self.findNaviViewControllerInVC(presentingViewController) {
                navi.pushViewController(self.destination, animated: true)
            } else {
                presentingViewController.present(self.destination, animated: true, completion: nil)
            }
        }
    }
    
    func findNaviViewControllerInVC(_ viewController:UIViewController) -> UINavigationController? {
        if let naviController = viewController as? UINavigationController {
            return naviController
        } else if let tabbarController = viewController as? UITabBarController,
            let selected = tabbarController.selectedViewController {
            return self.findNaviViewControllerInVC(_:selected)
        }
        
        return nil
    }
}
