//
//  LightBlueChipStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/24.
//
import UIKit

public protocol LightBlueChipStyleSupportable: ChipStyleSupportable {}

extension LightBlueChipStyleSupportable {
    public var chipColor: UIColor { .blue50 }
    public var textColor: UIColor { .blue500 }
    public var chipBorderColor: UIColor { .clear }
    public var deleteImage: UIImage? { UIImage(named: "ic_16_close_blue500") }
}
