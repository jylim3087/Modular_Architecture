//
//  LightGreenChipStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/24.
//
import UIKit

public protocol LightGreenChipStyleSupportable: ChipStyleSupportable {}

extension LightGreenChipStyleSupportable {
    public var chipColor: UIColor { .green50 }
    public var textColor: UIColor { .green500 }
    public var chipBorderColor: UIColor { .clear }
    public var deleteImage: UIImage? { UIImage(named: "ic_16_close_green500") }
}
