//
//  GraySolidButtonStyle.swift
//  DabangSwift
//
//  Created by 조동현 on 2021/05/13.
//
import UIKit

protocol GraySolidButtonComponentable: ButtonComponentable {}

extension GraySolidButtonComponentable {
    var enableColor: UIColor { .gray900 }
    var disableColor: UIColor { .gray400 }
    var enableBorderColor: UIColor { .clear }
    var disableBorderColor: UIColor { .clear }
}

protocol GraySolidButtonTitleSupportable: ButtonTitleSupportable {}

extension GraySolidButtonTitleSupportable {
    var enableTitleColor: UIColor { .white0 }
    var disableTitleColor: UIColor { .white0 }
}

protocol GraySolidButtonStyle: GraySolidButtonComponentable, GraySolidButtonTitleSupportable {}
