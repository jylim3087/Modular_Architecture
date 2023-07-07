//
//  AppDelegate.swift
//  page
//
//  Created by RIH on 2019/09/17.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable public class PageControlBase: UIControl {
    
    @IBInspectable var numberOfPages: Int = 0 {
        didSet {
            populateTintColors()
            updateNumberOfPages(numberOfPages)
        }
    }
    
    @IBInspectable var progress: Double = 0 {
        didSet {
            update(for: progress)
        }
    }
    
    public var currentPage: Int {
        return Int(round(progress))
    }
    
    @IBInspectable var padding: CGFloat = 5 {
        didSet {
            setNeedsLayout()
            update(for: progress)
        }
    }
    
    @IBInspectable var radius: CGFloat = 10 {
        didSet {
            setNeedsLayout()
            update(for: progress)
        }
    }
    
    @IBInspectable var inactiveTransparency: CGFloat = 0.6 {
        didSet {
            setNeedsLayout()
            update(for: progress)
        }
    }
    
    @IBInspectable var dotBorderWidth: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override public var tintColor: UIColor! {
        didSet {
            setNeedsLayout()
        }
    }
    
     var tintColors: [UIColor] = [] {
        didSet {
            guard tintColors.count == numberOfPages else {
                fatalError("The number of tint colors needs to be the same as the number of page")
            }
            setNeedsLayout()
        }
    }

    @IBInspectable var currentPageTintColor: UIColor? {
        didSet {
            setNeedsLayout()
        }
    }

    internal var moveToProgress: Double?
    
    private var displayLink: CADisplayLink?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDisplayLink()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDisplayLink()
    }
    
    func setupDisplayLink() {
        self.displayLink = CADisplayLink(target: WeakProxy(self), selector: #selector(updateFrame))
        self.displayLink?.add(to: .current, forMode: .common)
    }

    @objc func updateFrame() {
        self.animate()
    }
    
    func set(progress: Int, animated: Bool) {
        guard progress <= numberOfPages - 1 && progress >= 0 else { return }
        if animated == true {
            self.moveToProgress = Double(progress)
        } else {
            self.progress = Double(progress)
        }
    }
    
    func tintColor(position: Int) -> UIColor {
        if tintColors.count < numberOfPages {
            return tintColor
        } else {
            return tintColors[position]
        }
    }
    
    func insertTintColor(_ color: UIColor, position: Int) {
        if tintColors.count < numberOfPages {
            setupTintColors()
        }
        tintColors[position] = color
    }
    
    private func setupTintColors() {
        tintColors = Array<UIColor>(repeating: tintColor, count: numberOfPages)
    }
    
    private func populateTintColors() {
        guard tintColors.count > 0 else { return }
        
        if tintColors.count > numberOfPages {
            tintColors = Array(tintColors.prefix(numberOfPages))
        } else if tintColors.count < numberOfPages {
            tintColors.append(contentsOf: Array<UIColor>(repeating: tintColor, count: numberOfPages - tintColors.count))
        }
    }
    
    func animate() {
        guard let moveToProgress = self.moveToProgress else { return }
        
        let a = fabsf(Float(moveToProgress))
        let b = fabsf(Float(progress))
        
        if a > b {
            self.progress += 0.1
        }
        if a < b {
            self.progress -= 0.1
        }
        
        if a == b {
            self.progress = moveToProgress
            self.moveToProgress = nil
        }
        
        if self.progress < 0 {
            self.progress = 0
            self.moveToProgress = nil
        }
        
        if self.progress > Double(numberOfPages - 1) {
            self.progress = Double(numberOfPages - 1)
            self.moveToProgress = nil
        }
    }
    
    func updateNumberOfPages(_ count: Int) {
        fatalError("Should be implemented in child class")
    }
    
    func update(for progress: Double) {
        fatalError("Should be implemented in child class")
    }

    deinit {
        self.displayLink?.remove(from: .current, forMode: .common)
        self.displayLink?.invalidate()
    }
}

final class WeakProxy: NSObject {
    weak var target: NSObjectProtocol?

    init(_ target: NSObjectProtocol) {
        self.target = target
        super.init()
    }

    override func responds(to aSelector: Selector!) -> Bool {
        guard let target = target else { return super.responds(to: aSelector) }
        return target.responds(to: aSelector)
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }
}

extension Reactive where Base: PageControlBase {
    var animationCurrentIndex: Binder<Int> {
        return Binder(self.base) { controller, index in
            controller.set(progress: index, animated: true)
        }
    }
    
    var currentIndex: Binder<Int> {
        return Binder(self.base) { controller, index in
            controller.set(progress: index, animated: false)
        }
    }
}
