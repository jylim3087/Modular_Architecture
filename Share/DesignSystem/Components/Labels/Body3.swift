//
//  Body3.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2021/04/27.
//

import UIKit

fileprivate let body3_height: CGFloat = 24
fileprivate let body3_spacing: CGFloat = 7.295
fileprivate let body3_verticalPadding: CGFloat = 3.5

public class Body3Label: ComponentLabel {
    public override var lineHeight: CGFloat { body3_height }
    public override var lineSpacing: CGFloat { body3_spacing }
    public override var verticalPadding: CGFloat { body3_verticalPadding }
}

public class Body3_Regular: Body3Label {
    public override var labelFont: UIFont { .body3_regular }
}

public class Body3_Medium: Body3Label {
    public override var labelFont: UIFont { .body3_medium }
}

public class Body3_Bold: Body3Label {
    public override var labelFont: UIFont { .body3_bold }
}
