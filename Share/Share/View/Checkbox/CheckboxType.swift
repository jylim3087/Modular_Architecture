//
//  CheckboxType.swift
//  DabangSwift
//
//  Created by 진하늘 on 2019/10/16.
//  Copyright © 2019 young-soo park. All rights reserved.
//

import UIKit

enum CheckboxStyle {
    case square
    case round
}

extension CheckboxStyle {
    var selectImage: UIImage {
        switch self {
        case .square:
            return #imageLiteral(resourceName: "checkbox.pdf")
        case .round:
            return #imageLiteral(resourceName: "checkRoundSelect.pdf")
        }
    }
    
    var deselectImage: UIImage {
        switch self {
        case .square:
            return #imageLiteral(resourceName: "checkOff.pdf")
        case .round:
            return #imageLiteral(resourceName: "checkRoundNormal.pdf")
        }
    }
}

enum CheckboxState {
    case checked
    case unchecked
    
    func toggle() -> CheckboxState {
        return self == .checked ? .unchecked : .checked
    }
}

enum CheckboxAnimate {
    case none
    case fill
    case bounce
}
