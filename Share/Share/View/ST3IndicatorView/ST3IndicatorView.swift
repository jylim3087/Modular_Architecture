//
//  ST3IndicatorView.swift
//  ST3IndicatorView
//
//  Created by ybj on 2018. 9. 20..
//  Copyright © 2018년 ybj. All rights reserved.
//

import UIKit

public enum ST3IndicatorType: Int, CaseIterable {
    case ballPulseSync
    case logoSpin
    
    func animation() -> ST3IndicatorAnimationDelegate {
        switch self {
        case .ballPulseSync:
            return ST3IndicatorAnimationBallPulseSync()
        case .logoSpin:
            return ST3IndicatorAnimationLogoSpin()
        }
    }
}

public typealias FadeInAnimation = (UIView) -> Void

public typealias FadeOutAnimation = (UIView, @escaping () -> Void) -> Void

public final class ST3IndicatorView: UIView {

    //DEFAULT DEFINE
    public static var DEFAULT_TYPE: ST3IndicatorType = .ballPulseSync
    public static var DEFAULT_COLOR = UIColor.white
    public static var DEFAULT_TEXT_COLOR = UIColor.white
    public static var DEFAULT_PADDING: CGFloat = 0
    public static var DEFAULT_BLOCKER_SIZE = CGSize(width: 30, height: 30)
    public static var DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 0
    public static var DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 0
    public static var DEFAULT_BLOCKER_MESSAGE: String?
    public static var DEFAULT_BLOCKER_MESSAGE_SPACING = CGFloat(8.0)
    public static var DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 14)
    public static var DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    public static var DEFAULT_FADE_IN_ANIMATION: FadeInAnimation = { view in
        view.alpha = 0
        UIView.animate(withDuration: 0.25) { view.alpha = 1 }
    }
    
    public static var DEFAULT_FADE_OUT_ANIMATION: FadeOutAnimation = { (view, complete) in
        UIView.animate(withDuration: 0.25, animations: { view.alpha = 0 },
                       completion: { completed in if completed { complete() }
        })
    }

    //SET DEFAULT
    public var type: ST3IndicatorType = ST3IndicatorView.DEFAULT_TYPE
    
    @IBInspectable public var color: UIColor = ST3IndicatorView.DEFAULT_COLOR
    @IBInspectable public var padding: CGFloat = ST3IndicatorView.DEFAULT_PADDING
    
    @available(*, deprecated)
    public var animating: Bool { return isAnimating }
    private(set) public var isAnimating: Bool = false

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        isHidden = true
    }

    public init(frame: CGRect, type: ST3IndicatorType? = nil, color: UIColor? = nil, padding: CGFloat? = nil) {
        self.type = type ?? ST3IndicatorView.DEFAULT_TYPE
        self.color = color ?? ST3IndicatorView.DEFAULT_COLOR
        self.padding = padding ?? ST3IndicatorView.DEFAULT_PADDING
        super.init(frame: frame)
        isHidden = true
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    public override var bounds: CGRect {
        didSet {
            if oldValue != bounds && isAnimating {
                setUpAnimation()
            }
        }
    }

    public final func startAnimating() {
        isHidden = false
        isAnimating = true
        layer.speed = 1
        setUpAnimation()
    }
    
    public final func stopAnimating() {
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }
    
    private final func setUpAnimation() {
        let animation: ST3IndicatorAnimationDelegate = type.animation()
        var animationRect = frame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        let minEdge = min(animationRect.width, animationRect.height)
        
        layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animation.setUpAnimation(in: layer, size: animationRect.size, color: color)
    }
}
