//
//  H1_Regular.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2021/04/27.
//

import UIKit

fileprivate let h1_height: CGFloat = 51
fileprivate let h1_spacing: CGFloat = 12.815
fileprivate let h1_verticalPadding: CGFloat = 6.25

public class H1Label: ComponentLabel {
    public override var lineHeight: CGFloat { h1_height }
    public override var lineSpacing: CGFloat { h1_spacing }
    public override var verticalPadding: CGFloat { h1_verticalPadding }
}

public class H1_Regular: H1Label {
    public override var labelFont: UIFont { .h1_regular }
}

public class H1_Medium: H1Label {
    public override var labelFont: UIFont { .h1_medium }
}

public class H1_Bold: H1Label {
    public override var labelFont: UIFont { .h1_bold }
}
