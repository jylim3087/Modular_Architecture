//
//  LineBlueChipStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/01.
//
import UIKit

public protocol LineBlueChipStyleSupportable: ChipStyleSupportable {}

extension LineBlueChipStyleSupportable {
    public var chipColor: UIColor { .clear }
    public var textColor: UIColor { .blue500 }
    public var chipBorderColor: UIColor { .blue100 }
    public var deleteImage: UIImage? { UIImage(named: "ic_16_close_blue500") }
}
