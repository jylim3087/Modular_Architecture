//
//  TapItemType.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/22.
//

import UIKit

public protocol TapItemType {
    var title: String? { get }
    var subString: String? { get }
    var subStringColor: UIColor? { get }
}

extension TapItemType {
    public var subStringColor: UIColor? { .blue500 }
}

extension TapItemType where Self: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.title == rhs.title && lhs.subString == rhs.subString
    }
}

protocol TapItemTopSupporingType: TapItemType {
    var topString: String? { get }
}

extension TapItemTopSupporingType {
    var topString: String? { nil }
}
