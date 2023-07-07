//
//  LineTapGroups.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/22.
//

public final class BlueLineTapGroup<TapItem: TapItemType>: TapGroupComponent<LineTap, TapItem>, BlueLineTapGroupStyleSupportable {}

public final class GrayLineTapGroup<TapItem: TapItemType>: TapGroupComponent<LineTap, TapItem>, GrayLineTapGroupStyleSupportable {}

public final class BlueLineNumberTapGroup<TapItem: TapItemType>: TapGroupComponent<LineNumberTap, TapItem>, BlueLineTapGroupStyleSupportable {}

public final class GrayLineNumberTapGroup<TapItem: TapItemType>: TapGroupComponent<LineNumberTap, TapItem>, GrayLineTapGroupStyleSupportable {}

public final class BlueDoubleLineTapGroup<TapItem: TapItemType>: DoubleLineTapGroup<TapItem>, BlueLineTapGroupStyleSupportable {}

public final class GrayDoubleLineTapGroup<TapItem: TapItemType>: DoubleLineTapGroup<TapItem>, GrayLineTapGroupStyleSupportable {}
