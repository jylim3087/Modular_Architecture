//
//  ChoosableGroupMultipleSupportable.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/26.
//

public protocol ChoosableGroupMultipleSupportable {
    var isMultipleSelection: Bool { get }
}

public protocol ChoosableGroupTitleSupportable {
    var isRequired: Bool { get }
    var hasTitle: Bool { get }
}
