//
//  NavigationProgressBar.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 2. 13..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProgressBar : UIView {
    fileprivate var screenSize              : CGRect        = UIScreen.main.bounds
    fileprivate var isAnimating             : Bool          = false
    
    fileprivate var progressBarIndicator    : UIView!
    
    @IBInspectable var barBackgroundColor   : UIColor       = UIColor.white
    @IBInspectable var progressBarColor     : UIColor       = UIColor.fromRed(23, green: 109, blue: 225, alpha: 1.0)
    
    var heightForLinearBar                  : CGFloat       = 2
    var widthForLinearBar                   : CGFloat       = 0
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.progressBarIndicator = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: frame.height)))
        self.backgroundColor = .clear
        self.alpha = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.progressBarIndicator = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: frame.height)))
        self.backgroundColor = .clear
        self.alpha = 0.0
    }
    
    func startAnimation() {
        if !self.isAnimating {
            self.superview?.bringSubviewToFront(self)
            self.isAnimating = true
            self.configureColor()
            UIView.animate(withDuration: 0.2, animations: { 
                self.alpha = 1.0
                self.progressBarIndicator.alpha = 1.0
            }, completion: { (finished) in
                if finished {
                    self.addSubview(self.progressBarIndicator)
                    self.configureAnimation()
                }
            })
        }
    }
    
    func stopAnimation() {
        self.isAnimating = false
        UIView.animate(withDuration:0.5) { 
            self.progressBarIndicator.frame = CGRect(origin: .zero, size: self.frame.size)
            self.progressBarIndicator.alpha = 0.0
            self.alpha = 0.0
        }
    }
    
    private func configureAnimation() {
        self.progressBarIndicator.frame = CGRect(origin: .zero, size: CGSize(width: 0, height: self.frame.height))
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.progressBarIndicator.frame = CGRect(origin: .zero, size: CGSize(width: self.frame.width * 0.7, height: self.frame.height))
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.progressBarIndicator.frame = CGRect(origin: CGPoint(x: self.frame.width, y: 0), size: CGSize(width: 0, height: self.frame.height))
            }
        }, completion: { (finished) in
            if finished && self.isAnimating {
                self.configureAnimation()
            }
        })
    }
    private func configureColor() {
        self.backgroundColor = self.barBackgroundColor
        self.progressBarIndicator.backgroundColor = self.progressBarColor
    }
}

extension UIViewController {
    var isProgressAnimating : Bool {
        get {
            return self.st3Navigationbar?.isAnimating ?? false
        }
        set {
            self.st3Navigationbar?.isAnimating = newValue
        }
    }
    
    func startProgressAnimation() {
        self.st3Navigationbar?.startProgressAnimation()
    }
    
    func stopProgressAnimation() {
        self.st3Navigationbar?.stopProgressAnimation()
    }
}

extension ST3NavigationBar {
    var isAnimating : Bool {
        get {
            return self.progressBar.isAnimating
        }
        set {
            if newValue {
                self.progressBar.startAnimation()
            } else {
                self.progressBar.stopAnimation()
            }
        }
    }
    
    private var progressBar : ProgressBar {
        for subview in self.subviews {
            if let progressBar = subview as? ProgressBar {
                return progressBar
            }
        }
        let defaultHeight = CGFloat(2)
        let frame = CGRect(x: 0, y: self.frame.height - defaultHeight, width: self.frame.width, height: defaultHeight)
        let progressBar = ProgressBar(frame: frame)
        progressBar.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.addSubview(progressBar)
        progressBar.barBackgroundColor = self.backgroundColor ?? .clear
        return progressBar
    }
    
    func startProgressAnimation() {
        self.progressBar.barBackgroundColor = self.backgroundColor ?? .clear
        self.progressBar.startAnimation()
    }
    
    func stopProgressAnimation() {
        self.progressBar.stopAnimation()
    }
    
    var progressBarColor: UIColor {
        set { self.progressBar.progressBarColor = newValue }
        get { return self.progressBar.progressBarColor }
    }
}

extension Reactive where Base: UIViewController {
    var isProgressAnimating: Binder<Bool> {
        return Binder(base) { (vc, isLoading) in
            if isLoading {
                vc.startProgressAnimation()
            } else {
                vc.stopProgressAnimation()
            }
        }
    }
}
