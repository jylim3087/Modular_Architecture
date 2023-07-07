//
//  Array+Extension.swift
//  Share
//
//  Created by 임주영 on 2023/07/03.
//

import Foundation

extension Array {
    
    var jsonString : String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(data: jsonData, encoding: .utf8) ?? "[]"
        } catch {
            return "[]"
        }
    }
    
    subscript (safe index: Int) -> Element? {
        return startIndex <= index && index < endIndex ? self[index] : nil
    }
}

extension Array where Element == CGPoint {
    var bounds: CGRect {
        return self.reduce(CGRect.null) { (rect, point) in
            return rect.union(CGRect(origin: point, size: .zero))
        }
    }
}
