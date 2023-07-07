//
//  RedTextButtonStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/21.
//
import UIKit

protocol RedTextButtonComponentable: ButtonComponentable {}

extension RedTextButtonComponentable {
    var enableColor: UIColor { .white0 }
    var disableColor: UIColor { .gray100 }
    var enableBorderColor: UIColor { .clear }
    var disableBorderColor: UIColor { .clear }
}

protocol RedTextButtonTitleSupportable: ButtonTitleSupportable {}

extension RedTextButtonTitleSupportable {
    var enableTitleColor: UIColor { .red500 }
    var disableTitleColor: UIColor { .gray500 }
}

protocol RedTextButtonStyle: RedTextButtonComponentable, RedTextButtonTitleSupportable {}
