//
//  BlueLineTapGroupStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/22.
//
import Foundation
import UIKit

public protocol BlueLineTapGroupStyleSupportable: TapGroupStyleSupportable {}

extension BlueLineTapGroupStyleSupportable {
    public var gap: CGFloat { 32 }
    public var underLineColor: UIColor { .blue500 }
}

protocol BlueRoundLineTapGroupStyleSupportable: TapGroupStyleSupportable {}

extension BlueRoundLineTapGroupStyleSupportable {
    public var gap: CGFloat { 8 }
    public var underLineColor: UIColor { .clear }
}
