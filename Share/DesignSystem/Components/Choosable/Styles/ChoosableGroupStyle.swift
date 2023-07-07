//
//  ChoosableGroupStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/26.
//

public protocol SingleChoosableGroupSupportable: ChoosableGroupMultipleSupportable {}

extension SingleChoosableGroupSupportable {
    public var isMultipleSelection: Bool { false }
}

protocol MultipleChoosableGroupSupportable: ChoosableGroupMultipleSupportable {}

extension MultipleChoosableGroupSupportable {
    public var isMultipleSelection: Bool { true }
}

public protocol TitleChoosableGroupSupportable: ChoosableGroupTitleSupportable {}

extension TitleChoosableGroupSupportable {
    public var hasTitle: Bool { true }
    public var isRequired: Bool { false }
}

public protocol RequiredChoosableGroupSupportable: ChoosableGroupTitleSupportable {}

extension RequiredChoosableGroupSupportable {
    public var hasTitle: Bool { true }
    public var isRequired: Bool { true }
}
