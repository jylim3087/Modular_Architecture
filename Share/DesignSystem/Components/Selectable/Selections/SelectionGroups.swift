//
//  SelectionGroups.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/14.
//

public class SingleSelectionGroup: SelectableGroupComponent, SingleSelectableGroupSupportable {}

public class MultipleSelectionGroup: SelectableGroupComponent, MultipleSelectableGroupSupportable {}

public final class TitleSingleSelectionGroup: SingleSelectionGroup, TitleSelectableGroupSupportable {}

public final class TitleMultipleSelectionGroup: MultipleSelectionGroup, TitleSelectableGroupSupportable {}
