//
//  SelectableGroupMultipleSupportable.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/14.
//

protocol SelectableGroupMultipleSupportable {
    var isMultipleSelection: Bool { get }
}

protocol SelectableGroupTitleSupportable {
    var isRequired: Bool { set get }
    var hasTitle: Bool { get }
}

