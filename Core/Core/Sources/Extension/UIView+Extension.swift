//
//  UIView+Extension.swift
//  Core
//
//  Created by 임주영 on 2023/07/03.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable public var cornerRadius : CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    @IBInspectable public var borderWidth : CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    @IBInspectable public var borderColor : UIColor {
        get {
            if let cgcolor = self.layer.borderColor {
                return UIColor(cgColor: cgcolor)
            } else {
                return UIColor.clear
            }
        }
        set { self.layer.borderColor = newValue.cgColor }
    }
    
    @IBInspectable public var masksToBounds : Bool {
        get { return self.layer.masksToBounds }
        set { self.layer.masksToBounds = newValue }
    }
}

extension UIView {
    @IBInspectable public var layerShadowColor: UIColor? {
        set { self.layer.shadowColor = newValue?.cgColor }
        get {
            guard let shadowColor = self.layer.shadowColor else { return nil }
            return UIColor(cgColor: shadowColor)
        }
    }
    
    @IBInspectable public var layerShadowOffset: CGPoint {
        set { self.layer.shadowOffset = CGSize(width: newValue.x, height: -newValue.y) }
        get { return CGPoint(x: self.layer.shadowOffset.width, y: -self.layer.shadowOffset.height) }
    }
    
    @IBInspectable public var layerShadowOpacity: Float {
        set { self.layer.shadowOpacity = newValue }
        get { return self.layer.shadowOpacity }
    }
    
    @IBInspectable public var layerShadowRadius: CGFloat {
        set { self.layer.shadowRadius = newValue }
        get { return self.layer.shadowRadius }
    }
}

extension UIView {
    public func addGradientLayer(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 1), endPoint: CGPoint = CGPoint(x: 1, y: 0)) {
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
    public var snapshot : UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: context)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return viewImage
    }
    
    public func snapshotImageView() -> UIImageView? {
        guard let viewImage = self.snapshot else { return nil }
        return UIImageView(image: viewImage, highlightedImage: viewImage)
    }
}
