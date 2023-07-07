//
//  BlueTextButtonStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/21.
//
import UIKit

protocol BlueTextButtonComponentable: ButtonComponentable {}

extension BlueTextButtonComponentable {
    var enableColor: UIColor { .white0 }
    var disableColor: UIColor { .gray100 }
    var enableBorderColor: UIColor { .clear }
    var disableBorderColor: UIColor { .clear }
}

protocol BlueTextButtonTitleSupportable: ButtonTitleSupportable {}

extension BlueTextButtonTitleSupportable {
    var enableTitleColor: UIColor { .blue500 }
    var disableTitleColor: UIColor { .gray500 }
}

protocol BlueTextButtonStyle: BlueTextButtonComponentable, BlueTextButtonTitleSupportable {}
