//
//  LineGreenChipStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/01.
//
import UIKit

public protocol LineGreenChipStyleSupportable: ChipStyleSupportable {}

extension LineGreenChipStyleSupportable {
    public var chipColor: UIColor { .clear }
    public var textColor: UIColor { .green500 }
    public var chipBorderColor: UIColor { .green200 }
    public var deleteImage: UIImage? { UIImage(named: "ic_16_close_green500") }
}
