//
//  RadioGroups.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/26.
//

public class SingleRadioGroup: ChoosableGroupComponent<Radio>, SingleChoosableGroupSupportable {}

public class MultipleRadioGroup: ChoosableGroupComponent<Radio>, MultipleChoosableGroupSupportable {}

public final class TitleSingleRadioGroup: SingleRadioGroup, TitleChoosableGroupSupportable {}

public final class RequiredSingleRadioGroup: SingleRadioGroup, RequiredChoosableGroupSupportable {}

public final class TitleMultipleRadioGroup: MultipleRadioGroup, TitleChoosableGroupSupportable {}

public final class RequiredMultipleRadioGroup: MultipleRadioGroup, RequiredChoosableGroupSupportable {}
