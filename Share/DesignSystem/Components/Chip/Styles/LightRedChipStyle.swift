//
//  LightRedChipStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/24.
//
import UIKit

public protocol LightRedChipStyleSupportable: ChipStyleSupportable {}

extension LightRedChipStyleSupportable {
    public var chipColor: UIColor { .red50 }
    public var textColor: UIColor { .red500 }
    public var chipBorderColor: UIColor { .clear }
    public var deleteImage: UIImage? { UIImage(named: "ic_16_close_red500") }
}
