//
//  DarkGreenChipStyle.swift
//  DabangPro
//
//  Created by Edurado0727 on 2022/02/24.
//
import UIKit

public protocol DarkGreenChipStyleSupportable: ChipStyleSupportable {}

extension DarkGreenChipStyleSupportable {
    public var chipColor: UIColor { .green500 }
    public var textColor: UIColor { .white0 }
    public var chipBorderColor: UIColor { .clear }
    public var deleteImage: UIImage? { UIImage(named: "ic_16_close_white") }
}
