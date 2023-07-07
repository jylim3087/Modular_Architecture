//
//  ChipStyleSupportable.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/24.
//

import UIKit

public protocol ChipStyleSupportable {
    var chipColor: UIColor { get }
    var textColor: UIColor { get }
    var chipBorderColor: UIColor { get }
    var deleteImage: UIImage? { get }
}
