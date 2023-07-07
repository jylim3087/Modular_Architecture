//
//  CGRecet+Extension.swift
//  Share
//
//  Created by 임주영 on 2023/07/06.
//

import Foundation
extension CGRect {
    func centerXForRect(_ rect:CGRect) -> CGFloat {
        return (self.size.width     - rect.size.width)  / 2.0
    }
    
    func centerYForRect(_ rect:CGRect) -> CGFloat {
        return (self.size.height    - rect.size.height) / 2.0
    }
    
    func centerPointForRect(_ rect:CGRect) -> CGPoint {
        return CGPoint(x: self.centerXForRect(rect), y: self.centerYForRect(rect))
    }
}
