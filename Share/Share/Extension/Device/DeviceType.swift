//
//  DeviceType.swift
//  DabangSwift
//
//  Created by 김영수 on 2017. 7. 7..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit

public enum DeviceType: CGFloat {
    case unknown        = -1.0
    case iPhoneSE       = 568.0
    case iPhone7        = 667.0
    case iPhone7Plus    = 736.0
    case iPhoneX        = 812.0
    case iPhoneXRMsx    = 896.0

    public static var current: DeviceType {
        guard let deviceType: DeviceType = DeviceType(rawValue: UIScreen.main.bounds.size.height) else { return .unknown }
        return deviceType
    }
    
    public static func < (lhs:DeviceType, rhs:DeviceType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    public static func <= (lhs:DeviceType, rhs:DeviceType) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
    
    public static func > (lhs:DeviceType, rhs:DeviceType) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
    
    public static func >= (lhs:DeviceType, rhs:DeviceType) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }
    
    public var width: CGFloat {
        switch self {
        case .unknown:
            return -1.0
        case .iPhoneSE:
            return 320.0
        case .iPhone7:
            return 375.0
        case .iPhone7Plus, .iPhoneXRMsx:
            return 414.0
        case .iPhoneX:
            return 375.0
        }
    }
    
    public var height: CGFloat {
        return self.rawValue
    }
}

extension UIDevice {
    public var hasNotch: Bool {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        } else {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
    }
    
    public var topPadding: CGFloat {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        } else {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
        }
    }
    
    public var bottomPadding: CGFloat {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        } else {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        }
    }
}
