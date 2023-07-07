//
//  LightGrayChipStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/24.
//
import UIKit

public protocol LightGrayChipStyleSupportable: ChipStyleSupportable {}

extension LightGrayChipStyleSupportable {
    public var chipColor: UIColor { .gray200 }
    public var textColor: UIColor { .gray700 }
    public var chipBorderColor: UIColor { .clear }
    public var deleteImage: UIImage? { UIImage(named: "ic_16_close_gray700") }
}
