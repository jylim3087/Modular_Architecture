//
//  GrayLineButtonStyle.swift
//  DabangSwift
//
//  Created by 조동현 on 2021/05/13.
//
import UIKit

protocol GrayLineButtonComponentable: ButtonComponentable {}

extension GrayLineButtonComponentable {
    var enableColor: UIColor { .white0 }
    var disableColor: UIColor { .gray100 }
    var enableBorderColor: UIColor { .gray300 }
    var disableBorderColor: UIColor { .gray400 }
}

protocol GrayLineButtonTitleSupportable: ButtonTitleSupportable {}

extension GrayLineButtonTitleSupportable {
    var enableTitleColor: UIColor { .gray900 }
    var disableTitleColor: UIColor { .gray500 }
}

protocol GrayLineButtonStyle: GrayLineButtonComponentable, GrayLineButtonTitleSupportable {}
