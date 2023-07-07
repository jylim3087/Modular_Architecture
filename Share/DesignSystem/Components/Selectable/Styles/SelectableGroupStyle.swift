//
//  SelectableGroupStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/14.
//

protocol SingleSelectableGroupSupportable: SelectableGroupMultipleSupportable {}

extension SingleSelectableGroupSupportable {
    var isMultipleSelection: Bool { false }
}

protocol MultipleSelectableGroupSupportable: SelectableGroupMultipleSupportable {}

extension MultipleSelectableGroupSupportable {
    var isMultipleSelection: Bool { true }
}

protocol TitleSelectableGroupSupportable: SelectableGroupTitleSupportable {}

extension TitleSelectableGroupSupportable {
    var hasTitle: Bool { true }
}
