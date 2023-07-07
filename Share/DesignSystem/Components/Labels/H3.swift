//
//  H3.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2021/04/27.
//

import UIKit

fileprivate let h3_height: CGFloat = 38
fileprivate let h3_spacing: CGFloat = 9.359
fileprivate let h3_verticalPadding: CGFloat = 4.5

public class H3Label: ComponentLabel {
    public override var lineHeight: CGFloat { h3_height }
    public override var lineSpacing: CGFloat { h3_spacing }
    public override var verticalPadding: CGFloat { h3_verticalPadding }
}

public class H3_Regular: H3Label {
    public override var labelFont: UIFont { .h3_regular }
}

public class H3_Medium: H3Label {
    public override var labelFont: UIFont { .h3_medium }
}

public class H3_Bold: H3Label {
    public override var labelFont: UIFont { .h3_bold }
}
