//
//  ContainerTapGroupStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/22.
//
import UIKit
import Foundation

protocol ContainerTapGroupStyleSupportable: TapGroupStyleSupportable {}

extension ContainerTapGroupStyleSupportable {
    var gap: CGFloat { -1 }
    var underLineColor: UIColor { .clear }
}
