//
//  H2.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2021/04/27.
//

import UIKit

fileprivate let h2_height: CGFloat = 44
fileprivate let h2_spacing: CGFloat = 10.585
fileprivate let h2_verticalPadding: CGFloat = 5.25

public class H2Label: ComponentLabel {
    public override var lineHeight: CGFloat { h2_height }
    public override var lineSpacing: CGFloat { h2_spacing }
    public override var verticalPadding: CGFloat { h2_verticalPadding }
}

public class H2_Regular: H2Label {
    public override var labelFont: UIFont { .h2_regular }
}

public class H2_Medium: H2Label {
    public override var labelFont: UIFont { .h2_medium }
}

public class H2_Bold: H2Label {
    public override var labelFont: UIFont { .h2_bold }
}
