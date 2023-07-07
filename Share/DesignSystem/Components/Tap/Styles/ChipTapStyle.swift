//
//  ChipTapStyle.swift
//  DabangSwift
//
//  Created by pc on 2022/09/19.
//

import Foundation
import FlexLayout
import UIKit

public protocol ChipTapCompotable: TapStyleSuppotable { }

extension ChipTapCompotable {
   
    public var aligeItems: Flex.AlignItems { .center }
    
    public var enableColor: UIColor { .gray200 }
    public var disableColor: UIColor { .clear }
    public var selectedColor: UIColor { .blue50 }
    
    public var enableBorderColor: UIColor { .clear }
    public var disableBorderColor: UIColor { .clear }
    public var selectedBorderColor: UIColor { .blue500 }
    
    public var enableTitleColor: UIColor { .gray600 }
    public var disableTitleColor: UIColor { .clear }
    public var selectedTitleColor: UIColor { .blue500 }
    
    public var radius: CGFloat? { 14 }
   
    public var enableFont: UIFont? { UIFont.caption1_bold }
    public var selectedFont: UIFont? { UIFont.caption1_bold }
    
    public var paddingTop: CGFloat { 4 }
    public var paddingBottom: CGFloat { 4 }
    public var paddingLeft: CGFloat { 12 }
    public var paddingRight: CGFloat { 12 }
    
}
