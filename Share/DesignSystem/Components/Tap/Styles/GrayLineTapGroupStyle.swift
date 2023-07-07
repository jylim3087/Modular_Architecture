//
//  GrayLineTapGroupStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/22.
//
import UIKit
import Foundation

public protocol GrayLineTapGroupStyleSupportable: TapGroupStyleSupportable {}

extension GrayLineTapGroupStyleSupportable {
    public var gap: CGFloat { 32 }
    public var underLineColor: UIColor { .gray900 }
}
