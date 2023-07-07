//
//  ST3IndicatorAnimationDelegate.swift
//  ST3IndicatorView
//
//  Created by ybj on 2018. 9. 20..
//  Copyright © 2018년 ybj. All rights reserved.
//

import UIKit

protocol ST3IndicatorAnimationDelegate: AnyObject {
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor)
}
