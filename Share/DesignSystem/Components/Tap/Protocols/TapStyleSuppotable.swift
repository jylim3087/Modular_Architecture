//
//  TapStyleSuppotable.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/22.
//

import FlexLayout
import UIKit

public protocol TapStyleSuppotable {
    var aligeItems: Flex.AlignItems { get }
    
    var enableColor: UIColor { get }
    var disableColor: UIColor { get }
    var selectedColor: UIColor { get }
    
    var enableBorderColor: UIColor { get }
    var disableBorderColor: UIColor { get }
    var selectedBorderColor: UIColor { get }
    
    var enableTitleColor: UIColor { get }
    var disableTitleColor: UIColor { get }
    var selectedTitleColor: UIColor { get }
    
    var radius: CGFloat? { get }
    
    var paddingLeft: CGFloat { get }
    var paddingRight: CGFloat { get }
    var paddingTop: CGFloat { get }
    var paddingBottom: CGFloat { get }
    
    var enableFont: UIFont? { get }
    var selectedFont: UIFont? { get }

}
