//
//  LineTap.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/22.
//

public class LineTap: TapComponent, LineTapComponentable {}

public final class LineNumberTap: LineTap, TapSubStringSupportable {}

public class DoubleLineTap: TapComponent, DoubleLineTapComponentable, TapTopSupportable {}
