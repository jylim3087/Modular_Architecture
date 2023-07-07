//
//  ChipTapGroupStyle.swift
//  DabangSwift
//
//  Created by pc on 2022/09/19.
//

import Foundation
import UIKit

protocol ChipTapGroupStyleSupportable: TapGroupStyleSupportable {}

extension ChipTapGroupStyleSupportable {
    
    public var gap: CGFloat { 8 }
    public var underLineColor: UIColor { .clear }
}
