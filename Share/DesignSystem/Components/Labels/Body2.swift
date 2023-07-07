//
//  Body2.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2021/04/27.
//

import UIKit

fileprivate let body2_height: CGFloat = 26
fileprivate let body2_spacing: CGFloat = 6.91
fileprivate let body2_verticalPadding: CGFloat = 3.25

public class Body2Label: ComponentLabel {
    public override var lineHeight: CGFloat { body2_height }
    public override var lineSpacing: CGFloat { body2_spacing }
    public override var verticalPadding: CGFloat { body2_verticalPadding }
}

public class Body2_Regular: Body2Label {
    public override var labelFont: UIFont { .body2_regular }
}

public class Body2_Medium: Body2Label {
    public override var labelFont: UIFont { .body2_medium }
}

public class Body2_Bold: Body2Label {
    public override var labelFont: UIFont { .body2_bold }
}
