//
//  LineTapStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/22.
//

import FlexLayout
import CoreGraphics
import UIKit

public protocol LineTapComponentable: TapStyleSuppotable {}

extension LineTapComponentable {
    public var aligeItems: Flex.AlignItems { .end }
    public var paddingBottom: CGFloat { 8 }
    
    public var enableColor: UIColor { .clear }
    public var disableColor: UIColor { .clear }
    public var selectedColor: UIColor { .clear }
    
    public var enableBorderColor: UIColor { .clear }
    public var disableBorderColor: UIColor { .clear }
    public var selectedBorderColor: UIColor { .clear }
    
    public var enableTitleColor: UIColor { .gray900 }
    public var disableTitleColor: UIColor { .gray400 }
    public var selectedTitleColor: UIColor { .gray900 }
    
    public var radius: CGFloat? { nil }
    
    public var paddingLeft: CGFloat { 0 }
    public var paddingRight: CGFloat { 0 }
    public var paddingTop: CGFloat { 0 }
    
    public var enableFont: UIFont? { nil }
    public var selectedFont: UIFont? { nil }
}

public protocol DoubleLineTapComponentable: LineTapComponentable {}

extension DoubleLineTapComponentable {
    public var enableFont: UIFont? { .body3_bold }
    public var selectedFont: UIFont? { .body3_bold }
}
