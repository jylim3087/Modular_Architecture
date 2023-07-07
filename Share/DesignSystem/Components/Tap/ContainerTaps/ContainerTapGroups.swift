//
//  ContainerTapGroups.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/22.
//

final class ContainerTapGroup<TapItem: TapItemType>: TapGroupComponent<ContainerTap, TapItem>, ContainerTapGroupStyleSupportable {}

final class ContainerNumberTapGroup<TapItem: TapItemType>: TapGroupComponent<ContainerNumberTap, TapItem>, ContainerTapGroupStyleSupportable {}
