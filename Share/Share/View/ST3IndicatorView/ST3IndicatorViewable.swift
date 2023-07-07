//
//  ST3IndicatorViewable.swift
//  ST3IndicatorView
//
//  Created by ybj on 2018. 9. 20..
//  Copyright © 2018년 ybj. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public protocol ST3IndicatorViewable {}

public extension ST3IndicatorViewable where Self: UIViewController {
    
    var isAnimating: Bool { return ST3IndicatorPresenter.sharedInstance.isAnimating }

    func startAnimating( _ size: CGSize? = nil, message: String? = nil, messageFont: UIFont? = nil, type: ST3IndicatorType? = nil, color: UIColor? = nil,
                         padding: CGFloat? = nil, displayTimeThreshold: Int? = nil, minimumDisplayTime: Int? = nil, backgroundColor: UIColor? = nil,
                         textColor: UIColor? = nil, fadeInAnimation: FadeInAnimation? = ST3IndicatorView.DEFAULT_FADE_IN_ANIMATION) {
        
        let activityData = ActivityData(size: size, message: message, messageFont: messageFont, type: type, color: color,
                                        padding: padding, displayTimeThreshold: displayTimeThreshold, minimumDisplayTime: minimumDisplayTime,
                                        backgroundColor: backgroundColor, textColor: textColor)
        
        ST3IndicatorPresenter.sharedInstance.startAnimating(activityData, fadeInAnimation)
    }

    func stopAnimating(_ fadeOutAnimation: FadeOutAnimation? = ST3IndicatorView.DEFAULT_FADE_OUT_ANIMATION) {
        ST3IndicatorPresenter.sharedInstance.stopAnimating(fadeOutAnimation)
    }
}

public extension ST3IndicatorViewable where Self: UIView {
    
    var isAnimating: Bool { return ST3IndicatorPresenter.sharedInstance.isAnimating }

    func startAnimating( _ size: CGSize? = nil, message: String? = nil, messageFont: UIFont? = nil, type: ST3IndicatorType? = nil, color: UIColor? = nil,
                         padding: CGFloat? = nil, displayTimeThreshold: Int? = nil, minimumDisplayTime: Int? = nil, backgroundColor: UIColor? = nil,
                         textColor: UIColor? = nil, fadeInAnimation: FadeInAnimation? = ST3IndicatorView.DEFAULT_FADE_IN_ANIMATION) {
        
        let activityData = ActivityData(size: size, message: message, messageFont: messageFont, type: type, color: color,
                                        padding: padding, displayTimeThreshold: displayTimeThreshold, minimumDisplayTime: minimumDisplayTime,
                                        backgroundColor: backgroundColor, textColor: textColor)
        
        ST3IndicatorPresenter.sharedInstance.startAnimating(activityData, fadeInAnimation)
    }

    func stopAnimating(_ fadeOutAnimation: FadeOutAnimation? = ST3IndicatorView.DEFAULT_FADE_OUT_ANIMATION) {
        ST3IndicatorPresenter.sharedInstance.stopAnimating(fadeOutAnimation)
    }
}

extension Reactive where Base: UIViewController, Base: ST3IndicatorViewable {
    var indicatorAnimating: Binder<Bool> {
        return Binder(base) { (vc, animating) in
            if animating {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        }
    }
}
