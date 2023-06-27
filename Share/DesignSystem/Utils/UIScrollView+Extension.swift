//
//  UIScrollView+Extension.swift
//  Share
//
//  Created by 임주영 on 2023/06/27.
//

import UIKit

extension UIScrollView {
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    public var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
}
