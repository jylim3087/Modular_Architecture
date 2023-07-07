//
//  Subtitle2.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2021/04/27.
//

import UIKit

fileprivate let subtitle2_height: CGFloat = 32
fileprivate let subtitle2_spacing: CGFloat = 8.13
fileprivate let subtitle2_verticalPadding: CGFloat = 4

public class Subtitle2Label: ComponentLabel {
    public override var lineHeight: CGFloat { subtitle2_height }
    public override var lineSpacing: CGFloat { subtitle2_spacing }
    public override var verticalPadding: CGFloat { subtitle2_verticalPadding }
}

public class Subtitle2_Regular: Subtitle2Label {
    public override var labelFont: UIFont { .subtitle2_regular }
}

public class Subtitle2_Medium: Subtitle2Label {
    public override var labelFont: UIFont { .subtitle2_medium }
}

public class Subtitle2_Bold: Subtitle2Label {
    public override var labelFont: UIFont { .subtitle2_bold }
}

