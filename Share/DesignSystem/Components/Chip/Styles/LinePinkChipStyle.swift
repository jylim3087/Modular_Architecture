//
//  LinePinkChipStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/01.
//
import UIKit

public protocol LinePinkChipStyleSupportable: ChipStyleSupportable {}

extension LinePinkChipStyleSupportable {
    public var chipColor: UIColor { .clear }
    public var textColor: UIColor { .pink500 }
    public var chipBorderColor: UIColor { .pink100 }
    public var deleteImage: UIImage? { UIImage(named: "ic_16_close_pink500") }
}
