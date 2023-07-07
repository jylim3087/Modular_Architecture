//
//  RadioChoosableStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/26.
//

import UIKit

public final class RadioChoosableStyle: ChoosableStyle {
    public override var toggleImage: UIImage? {
        var named: String
        switch status {
        case .enabled:
            named = "ic_24_radio_enabled"
        case .selected:
            named = "ic_24_radio_selected"
        case .selectedDisabled:
            named = "ic_24_radio_selected_disabled"
        case .disabled:
            named = "ic_24_radio_disabled"
        }

        return UIImage(named: named)
    }
}
