//
//  GrayTooltipStyle.swift
//  DabangSwift
//
//  Created by 조동현 on 2022/08/09.
//

import UIKit

public protocol GrayTooltipStyle: TooltipStyleSuppotable {}

extension GrayTooltipStyle {
    public var arrowColor: String { "gray900" }
    public var tooltipColor: UIColor { .gray900 }
}
