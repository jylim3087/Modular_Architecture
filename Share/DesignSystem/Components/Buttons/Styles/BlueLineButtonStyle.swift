//
//  BlueLineButtonStyle.swift
//  DabangSwift
//
//  Created by 조동현 on 2021/05/13.
//
import UIKit

protocol BlueLineButtonComponentable: ButtonComponentable {}

extension BlueLineButtonComponentable {
    var enableColor: UIColor { .white0 }
    var disableColor: UIColor { .gray100 }
    var enableBorderColor: UIColor { .blue500 }
    var disableBorderColor: UIColor { .gray400 }
}

protocol BlueLineButtonTitleSupportable: ButtonTitleSupportable {}

extension BlueLineButtonTitleSupportable {
    var enableTitleColor: UIColor { .blue500 }
    var disableTitleColor: UIColor { .gray500 }
}

protocol BlueLineButtonStyle: BlueLineButtonComponentable, BlueLineButtonTitleSupportable {}
