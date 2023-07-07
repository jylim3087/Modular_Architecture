//
//  Caption2.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2021/04/27.
//

import UIKit

fileprivate let caption2_height: CGFloat = 16
fileprivate let caption2_spacing: CGFloat = 4.065
fileprivate let caption2_verticalPadding: CGFloat = 2

public class Caption2Label: ComponentLabel {
    public override var lineHeight: CGFloat { caption2_height }
    public override var lineSpacing: CGFloat { caption2_spacing }
    public override var verticalPadding: CGFloat { caption2_verticalPadding }
}

public class Caption2_Regular: Caption2Label {
    public override var labelFont: UIFont { .caption2_regular }
}

public class Caption2_Medium: Caption2Label {
    public override var labelFont: UIFont { .caption2_medium }
}

public class Caption2_Bold: Caption2Label {
    public override var labelFont: UIFont { .caption2_bold }
}

