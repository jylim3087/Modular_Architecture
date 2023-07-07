//
//  BlueSolidButtonStyle.swift
//  DabangSwift
//
//  Created by 조동현 on 2021/05/13.
//
import UIKit
 
protocol BlueSolidButtonComponentable: ButtonComponentable {}

extension BlueSolidButtonComponentable {
    var enableColor: UIColor { .blue500 }
    var disableColor: UIColor { .gray400 }
    var enableBorderColor: UIColor { .clear }
    var disableBorderColor: UIColor { .clear }
}

protocol BlueSolidButtonTitleSupportable: ButtonTitleSupportable {}

extension BlueSolidButtonTitleSupportable {
    var enableTitleColor: UIColor { .white0 }
    var disableTitleColor: UIColor { .white0 }
}

protocol BlueSolidButtonStyle: BlueSolidButtonComponentable, BlueSolidButtonTitleSupportable {}
