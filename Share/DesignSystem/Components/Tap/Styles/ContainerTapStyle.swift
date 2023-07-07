//
//  ContainerTapStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/22.
//

import FlexLayout
import UIKit
import Foundation

protocol ContainerTapComponentable: TapStyleSuppotable {}

extension ContainerTapComponentable {
    var aligeItems: Flex.AlignItems { .center }
    var paddingBottom: CGFloat { 0 }
    
    var enableColor: UIColor { .clear }
    var disableColor: UIColor { .gray400 }
    var selectedColor: UIColor { .gray900 }
    
    var enableBorderColor: UIColor { .gray300 }
    var disableBorderColor: UIColor { .gray400 }
    var selectedBorderColor: UIColor { .gray900 }
    
    var enableTitleColor: UIColor { .gray900 }
    var disableTitleColor: UIColor { .white0 }
    var selectedTitleColor: UIColor { .white0 }
    
    var radius: CGFloat? { nil }
    
    var paddingLeft: CGFloat { 0 }
    var paddingRight: CGFloat { 0 }
    var paddingTop: CGFloat { 0 }

    var enableFont: UIFont? { nil }
    var selectedFont: UIFont? { nil }
    
}
