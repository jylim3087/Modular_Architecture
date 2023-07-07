//
//  ButtonComponentHeightType.swift
//  DabangSwift
//
//  Created by 조동현 on 2021/05/13.
//
import Foundation

enum ButtonComponentHeightType: CGFloat {
    case xlarge = 56
    case large = 44
    case medium = 36
    case small = 28
}

extension ButtonComponentHeightType {
    var paddingVertical: CGFloat {
        switch self {
        case .xlarge: return 5
        default: return 2
        }
    }
}
