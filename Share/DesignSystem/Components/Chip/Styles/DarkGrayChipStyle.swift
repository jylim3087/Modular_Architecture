//
//  DarkGrayChipStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/24.
//

import UIKit

protocol DarkGrayChipStyleSupportable: ChipStyleSupportable {}

extension DarkGrayChipStyleSupportable {
    public var chipColor: UIColor { .gray900 }
    public var textColor: UIColor { .white0 }
    public var chipBorderColor: UIColor { .clear }
    public var deleteImage: UIImage? { UIImage(named: "ic_16_close_white") }
}
