//
//  LightPinkChipStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/01.
//
import UIKit

public protocol LightPinkChipStyleSupportable: ChipStyleSupportable {}

extension LightPinkChipStyleSupportable {
    public var chipColor: UIColor { .pink50 }
    public var textColor: UIColor { .pink500 }
    public var chipBorderColor: UIColor { .clear }
    public var deleteImage: UIImage? { UIImage(named: "ic_16_close_pink500") }
}
