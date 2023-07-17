//
//  ButtonIconSupportable.swift
//  DabangSwift
//
//  Created by 조동현 on 2021/05/13.
//
import UIKit

public enum ButtonIconAlignment {
    case left
    case right
    case top
    case bottom
}

extension ButtonIconAlignment {
    var isVertical: Bool {
        self == .top || self == .bottom
    }
}

public protocol ButtonIconSupportable: UIButton {
    func setIcon(_ icon: UIImage?, _ alignment: ButtonIconAlignment)
    
//    add
//    direction, margin
}

extension ButtonIconSupportable {
    public func setIcon(_ icon: UIImage?, _ alignment: ButtonIconAlignment = .left) {
        setImage(icon, for: .normal)
        
        if alignment == .right {
            semanticContentAttribute = .forceRightToLeft
        }
    }
}
