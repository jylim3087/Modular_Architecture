//
//  LineGrayChipStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/01.
//
import UIKit

public protocol LineGrayChipStyleSupportable: ChipStyleSupportable {}

extension LineGrayChipStyleSupportable {
    public var chipColor: UIColor { .clear }
    public var textColor: UIColor { .gray900 }
    public var chipBorderColor: UIColor { .gray400 }
    public var deleteImage: UIImage? { UIImage(named: "ic_16_close_gray900") }
}
