//
//  DarkPinkChipStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/01.
//
import UIKit

public protocol DarkPinkChipStyleSupportable: ChipStyleSupportable {}

extension DarkPinkChipStyleSupportable {
    public var chipColor: UIColor { .pink500 }
    public var textColor: UIColor { .white0 }
    public var chipBorderColor: UIColor { .clear }
    public var deleteImage: UIImage? { UIImage(named: "ic_16_close_white") }
}

