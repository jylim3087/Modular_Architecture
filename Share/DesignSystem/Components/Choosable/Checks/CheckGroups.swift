//
//  CheckGroups.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/26.
//

public class SingleCheckGroup: ChoosableGroupComponent<Check>, SingleChoosableGroupSupportable {}

public class MultipleCheckGroup: ChoosableGroupComponent<Check>, MultipleChoosableGroupSupportable {}

public final class TitleSingleCheckGroup: SingleCheckGroup, TitleChoosableGroupSupportable {}

public final class RequiredSingleCheckGroup: SingleCheckGroup, RequiredChoosableGroupSupportable {}

public final class TitleMultipleCheckGroup: MultipleCheckGroup, TitleChoosableGroupSupportable {}

public final class RequiredMultipleCheckGroup: MultipleCheckGroup, RequiredChoosableGroupSupportable {}
