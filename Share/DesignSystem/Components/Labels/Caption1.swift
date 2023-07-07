//
//  Caption1.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2021/04/27.
//

import UIKit

fileprivate let caption1_height: CGFloat = 20
fileprivate let caption1_spacing: CGFloat = 5.676
fileprivate let caption1_verticalPadding: CGFloat = 2.75

public class Caption1Label: ComponentLabel {
    public override var lineHeight: CGFloat { caption1_height }
    public override var lineSpacing: CGFloat { caption1_spacing }
    public override var verticalPadding: CGFloat { caption1_verticalPadding }
}

public class Caption1_Regular: Caption1Label {
    public override var labelFont: UIFont { .caption1_regular }
}

public class Caption1_Medium: Caption1Label {
    public override var labelFont: UIFont { .caption1_medium }
}

public class Caption1_Bold: Caption1Label {
    public override var labelFont: UIFont { .caption1_bold }
}
