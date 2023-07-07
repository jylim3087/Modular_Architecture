//
//  CheckChoosableStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/26.
//

import UIKit

public class CheckChoosableStyle: ChoosableStyle {
    public override var toggleImage: UIImage? {
        var named: String
        switch status {
        case .enabled:
            named = "ic_24_checkbox_enabled"
        case .selected:
            named = "ic_24_checkbox_checked"
        case .selectedDisabled:
            named = "ic_24_checkbox_checked_disabled"
        case .disabled:
            named = "ic_24_checkbox_disabled"
        }

        return UIImage(named: named)
    }
}

public final class MultiLineCheckChoosableStyle: CheckChoosableStyle {
    public override var multiLine: Bool { true }
}
