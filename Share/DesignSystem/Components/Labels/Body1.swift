//
//  Body1.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2021/04/27.
//

import UIKit

fileprivate let body1_height: CGFloat = 30
fileprivate let body1_spacing: CGFloat = 8.515
fileprivate let body1_verticalPadding: CGFloat = 4.25

public class Body1Label: ComponentLabel {
    public override var lineHeight: CGFloat { body1_height }
    public override var lineSpacing: CGFloat { body1_spacing }
    public override var verticalPadding: CGFloat { body1_verticalPadding }
}

public class Body1_Regular: Body1Label {
    public override var labelFont: UIFont { .body1_regular }
}

public class Body1_Medium: Body1Label {
    public override var labelFont: UIFont { .body1_medium }
}

public class Body1_Bold: Body1Label {
    public override var labelFont: UIFont { .body1_bold }
}
