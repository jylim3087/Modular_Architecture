//
//  UIView+layer.swift
//  DabangSwift
//
//  Created by Kim JungMoo on 03/12/2018.
//  Copyright © 2018 young-soo park. All rights reserved.
//

import UIKit
import RxSwift

extension UIView {
    @IBInspectable var cornerRadius : CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWidth : CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor : UIColor {
        get {
            if let cgcolor = self.layer.borderColor {
                return UIColor(cgColor: cgcolor)
            } else {
                return UIColor.clear
            }
        }
        set { self.layer.borderColor = newValue.cgColor }
    }
    
    @IBInspectable var masksToBounds : Bool {
        get { return self.layer.masksToBounds }
        set { self.layer.masksToBounds = newValue }
    }
}

extension UIView {
    @IBInspectable var layerShadowColor: UIColor? {
        set { self.layer.shadowColor = newValue?.cgColor }
        get {
            guard let shadowColor = self.layer.shadowColor else { return nil }
            return UIColor(cgColor: shadowColor)
        }
    }
    
    @IBInspectable var layerShadowOffset: CGPoint {
        set { self.layer.shadowOffset = CGSize(width: newValue.x, height: -newValue.y) }
        get { return CGPoint(x: self.layer.shadowOffset.width, y: -self.layer.shadowOffset.height) }
    }
    
    @IBInspectable var layerShadowOpacity: Float {
        set { self.layer.shadowOpacity = newValue }
        get { return self.layer.shadowOpacity }
    }
    
    @IBInspectable var layerShadowRadius: CGFloat {
        set { self.layer.shadowRadius = newValue }
        get { return self.layer.shadowRadius }
    }
}

extension UIView {
    func addGradientLayer(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 1), endPoint: CGPoint = CGPoint(x: 1, y: 0)) {
        let colorObjects = colors.map { return $0.cgColor }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = UIScreen.main.bounds
        gradientLayer.colors = colorObjects
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIView {
    var snapshot : UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: context)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return viewImage
    }
    
    func snapshotImageView() -> UIImageView? {
        guard let viewImage = self.snapshot else { return nil }
        return UIImageView(image: viewImage, highlightedImage: viewImage)
    }
}
extension UIView {
    @discardableResult
    public func viewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController { return viewController }
        } while nextResponder != nil
        
        return nil
    }
    
    public var flexHidden: Bool {
        set {
            self.isHidden = newValue
            self.flex.isIncludedInLayout(!newValue)
        }
        
        get {
            return self.isHidden
        }
    }
    
    func markDirtyWidth() {
        flex.markDirty()
        pin.sizeToFit(.width)
        
        flex.layout(mode: .adjustWidth)
    }

    func markDirtyHeight() {
        flex.markDirty()
        pin.sizeToFit(.height)
        
        flex.layout(mode: .adjustHeight)
    }
}

extension Reactive where Base: UIView {
    var flexHidden: Binder<Bool> {
        return Binder.init(base) { (view, hidden) in
            view.flexHidden = hidden
        }
    }
}
