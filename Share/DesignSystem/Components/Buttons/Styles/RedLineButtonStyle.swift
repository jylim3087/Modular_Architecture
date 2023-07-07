//
//  RedLineButtonStyle.swift
//  DabangSwift
//
//  Created by 조동현 on 2021/05/13.
//
import UIKit

protocol RedLineButtonComponentable: ButtonComponentable {}

extension RedLineButtonComponentable {
    var enableColor: UIColor { .white0 }
    var disableColor: UIColor { .gray100 }
    var enableBorderColor: UIColor { .red500 }
    var disableBorderColor: UIColor { .gray400 }
}

protocol RedLineButtonTitleSupportable: ButtonTitleSupportable {}

extension RedLineButtonTitleSupportable {
    var enableTitleColor: UIColor { .red500 }
    var disableTitleColor: UIColor { .gray500 }
}

protocol RedLineButtonStyle: RedLineButtonComponentable, RedLineButtonTitleSupportable {}
