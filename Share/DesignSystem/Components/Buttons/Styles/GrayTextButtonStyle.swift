//
//  GrayTextButtonStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/21.
//
import UIKit

protocol GrayTextButtonComponentable: ButtonComponentable {}

extension GrayTextButtonComponentable {
    var enableColor: UIColor { .white0 }
    var disableColor: UIColor { .gray100 }
    var enableBorderColor: UIColor { .clear }
    var disableBorderColor: UIColor { .clear }
}

protocol GrayTextButtonTitleSupportable: ButtonTitleSupportable {}

extension GrayTextButtonTitleSupportable {
    var enableTitleColor: UIColor { .gray900 }
    var disableTitleColor: UIColor { .gray500 }
}

protocol GrayTextButtonStyle: GrayTextButtonComponentable, GrayTextButtonTitleSupportable {}
