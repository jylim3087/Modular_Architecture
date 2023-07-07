//
//  RedSolidButtonStyle.swift
//  DabangSwift
//
//  Created by 조동현 on 2021/05/13.
//

import UIKit

protocol RedSolidButtonComponentable: ButtonComponentable {}

extension RedSolidButtonComponentable {
    var enableColor: UIColor { .red500 }
    var disableColor: UIColor { .gray400 }
    var enableBorderColor: UIColor { .clear }
    var disableBorderColor: UIColor { .clear }
}

protocol RedSolidButtonTitleSupportable: ButtonTitleSupportable {}

extension RedSolidButtonTitleSupportable {
    var enableTitleColor: UIColor { .white0 }
    var disableTitleColor: UIColor { .white0 }
}

protocol RedSolidButtonStyle: RedSolidButtonComponentable, RedSolidButtonTitleSupportable {}
