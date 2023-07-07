//
//  BlueTooltipStyle.swift
//  DabangSwift
//
//  Created by 조동현 on 2022/08/09.
//

import UIKit

public protocol BlueTooltipStyle: TooltipStyleSuppotable {}

extension BlueTooltipStyle {
    public var arrowColor: String { "blue500" }
    public var tooltipColor: UIColor { .blue500 }
}
