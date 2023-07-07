//
//  LineRedChipStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/01.
//
import UIKit

public protocol LineRedChipStyleSupportable: ChipStyleSupportable {}

extension LineRedChipStyleSupportable {
    public var chipColor: UIColor { .clear }
    public var textColor: UIColor { .red500 }
    public var chipBorderColor: UIColor { .red100 }
    public var deleteImage: UIImage? { UIImage(named: "ic_16_close_red500") }
}

