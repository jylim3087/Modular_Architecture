//
//  Fonts.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2021/04/26.
//

import UIKit

extension UIFont {
    private static let h1_size: CGFloat = 32
    private static let h2_size: CGFloat = 28
    private static let h3_size: CGFloat = 24
    private static let subtitle1_size: CGFloat = 22
    private static let subtitle2_size: CGFloat = 20
    private static let body1_size: CGFloat = 18
    private static let body2_size: CGFloat = 16
    private static let body3_size: CGFloat = 14
    private static let caption1_size: CGFloat = 12
    private static let caption2_size: CGFloat = 10
    
    
    public static var h1_regular: UIFont { return .systemFont(ofSize: h1_size) }
    public static var h1_medium: UIFont { return .systemFont(ofSize: h1_size, weight: .medium) }
    public static var h1_bold: UIFont { return .systemFont(ofSize: h1_size, weight: .bold) }
    
    public static var h2_regular: UIFont { return .systemFont(ofSize: h2_size) }
    public static var h2_medium: UIFont { return .systemFont(ofSize: h2_size, weight: .medium) }
    public static var h2_bold: UIFont { return .systemFont(ofSize: h2_size, weight: .bold) }
    
    public static var h3_regular: UIFont { return .systemFont(ofSize: h3_size) }
    public static var h3_medium: UIFont { return .systemFont(ofSize: h3_size, weight: .medium) }
    public static var h3_bold: UIFont { return .systemFont(ofSize: h3_size, weight: .bold) }
    
    public static var subtitle1_regular: UIFont { return .systemFont(ofSize: subtitle1_size) }
    public static var subtitle1_medium: UIFont { return .systemFont(ofSize: subtitle1_size, weight: .medium) }
    public static var subtitle1_bold: UIFont { return .systemFont(ofSize: subtitle1_size, weight: .bold) }
    
    public static var subtitle2_regular: UIFont { return .systemFont(ofSize: subtitle2_size) }
    public static var subtitle2_medium: UIFont { return .systemFont(ofSize: subtitle2_size, weight: .medium) }
    public static var subtitle2_bold: UIFont { return .systemFont(ofSize: subtitle2_size, weight: .bold) }
    
    public static var body1_regular: UIFont { return .systemFont(ofSize: body1_size) }
    public static var body1_medium: UIFont { return .systemFont(ofSize: body1_size, weight: .medium) }
    public static var body1_bold: UIFont { return .systemFont(ofSize: body1_size, weight: .bold) }
    
    public static var body2_regular: UIFont { return .systemFont(ofSize: body2_size) }
    public static var body2_medium: UIFont { return .systemFont(ofSize: body2_size, weight: .medium) }
    public static var body2_bold: UIFont { return .systemFont(ofSize: body2_size, weight: .bold) }
    
    public static var body3_regular: UIFont { return .systemFont(ofSize: body3_size) }
    public static var body3_medium: UIFont { return .systemFont(ofSize: body3_size, weight: .medium) }
    public static var body3_bold: UIFont { return .systemFont(ofSize: body3_size, weight: .bold) }
    
    public static var caption1_regular: UIFont { return .systemFont(ofSize: caption1_size) }
    public static var caption1_medium: UIFont { return .systemFont(ofSize: caption1_size, weight: .medium) }
    public static var caption1_bold: UIFont { return .systemFont(ofSize: caption1_size, weight: .bold) }
    
    public static var caption2_regular: UIFont { return .systemFont(ofSize: caption2_size) }
    public static var caption2_medium: UIFont { return .systemFont(ofSize: caption2_size, weight: .medium) }
    public static var caption2_bold: UIFont { return .systemFont(ofSize: caption2_size, weight: .bold) }
}
