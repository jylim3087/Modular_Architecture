//
//  ButtonHeightSupportable.swift
//  DabangSwift
//
//  Created by 조동현 on 2021/05/13.
//
import UIKit

protocol ButtonHeightSupportable {
    var height: ButtonComponentHeightType { get }
    var titleFont: UIFont { get }
    var verticalTitleFont: UIFont { get }
}

protocol ButtonXLargeHeightSupportable: ButtonHeightSupportable {}

extension ButtonXLargeHeightSupportable {
    var height: ButtonComponentHeightType { return .xlarge }
    var titleFont: UIFont { return .body3_bold }
    var verticalTitleFont: UIFont { return .caption1_bold }
}

protocol ButtonLargeHeightSupportable: ButtonHeightSupportable {}

extension ButtonLargeHeightSupportable {
    var height: ButtonComponentHeightType { return .large }
    var titleFont: UIFont { return .body3_bold }
    var verticalTitleFont: UIFont { return .caption2_bold }
}

protocol ButtonMediumHeightSupportable: ButtonHeightSupportable {}

extension ButtonMediumHeightSupportable {
    var height: ButtonComponentHeightType { return .medium }
    var titleFont: UIFont { return .body3_bold }
    var verticalTitleFont: UIFont { return .caption2_bold }
}

protocol ButtonSmallHeightSupportable: ButtonHeightSupportable {}

extension ButtonSmallHeightSupportable {
    var height: ButtonComponentHeightType { return .small }
    var titleFont: UIFont { return .caption1_bold }
    var verticalTitleFont: UIFont { return .caption2_bold }
}
