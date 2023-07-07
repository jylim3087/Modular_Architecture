//
//  Subtitle1.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2021/04/27.
//

import UIKit

fileprivate let subtitle1_height: CGFloat = 38
fileprivate let subtitle1_spacing: CGFloat = 11.745
fileprivate let subtitle1_verticalPadding: CGFloat = 5.75

public class Subtitle1Label: ComponentLabel {
    public override var lineHeight: CGFloat { subtitle1_height }
    public override var lineSpacing: CGFloat { subtitle1_spacing }
    public override var verticalPadding: CGFloat { subtitle1_verticalPadding }
}

public class Subtitle1_Regular: Subtitle1Label {
    public override var labelFont: UIFont { .subtitle1_regular }
}

public class Subtitle1_Medium: Subtitle1Label {
    public override var labelFont: UIFont { .subtitle1_medium }
}

public class Subtitle1_Bold: Subtitle1Label {
    public override var labelFont: UIFont { .subtitle1_bold }
}
