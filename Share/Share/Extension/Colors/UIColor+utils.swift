//
//  UIColor+utils.swift
//  Share
//
//  Created by 임주영 on 2023/06/26.
//

import UIKit

extension UIColor {
    static func getColor(name: String) -> UIColor {
        return UIColor(named: name, in: Bundle(for: Share.ShareResources.self), compatibleWith: nil)!
    }
    
    public static var highlightedCellColor: UIColor {
        return UIColor.fromRed(236, green: 236, blue: 236, alpha: 1)
    }
    
    public static func fromRGBString(hexString:String) -> UIColor {
        var hexString : String = hexString
        hexString = hexString.replacingOccurrences(of: "#", with: "0x")
        let scanner = Scanner(string: hexString)
        var value : UInt32 = 0
        if scanner.scanHexInt32(&value) {
            return UIColor.fromRGB(rgbValue: Int(value))
        }
        return UIColor.black
    }
    
    public static func fromRGB(rgbValue:Int) -> UIColor {
        let r = ( (Float) ( (rgbValue & 0xFF0000) >> 16 ) ) / 255.0
        let g = ( (Float) ( (rgbValue & 0x00FF00) >> 8  ) ) / 255.0
        let b = ( (Float) ( (rgbValue & 0x0000FF) >> 0  ) ) / 255.0
        let a = 1.0
        return UIColor.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
    }
    
    public static func fromRGBA(rgbValue:Int, alpha:CGFloat) -> UIColor {
        let r = ( (Float) ( (rgbValue & 0xFF0000) >> 16 ) ) / 255.0
        let g = ( (Float) ( (rgbValue & 0x00FF00) >> 8  ) ) / 255.0
        let b = ( (Float) ( (rgbValue & 0x0000FF) >> 0  ) ) / 255.0
        return UIColor.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: alpha)
    }
    
    public static func fromRed(_ red:Int, green:Int, blue:Int, alpha:CGFloat = 1.0) -> UIColor {
        let r = CGFloat(red) / 255.0
        let g = CGFloat(green) / 255.0
        let b = CGFloat(blue) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    // MARK: - Color Blend
    public func blendColor(targetColor: UIColor, ratio: CGFloat) -> UIColor {
        let inverseRation = 1.0 - ratio
        
        var rgb1: (CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0)
        var rgb2: (CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0)
        
        self.getRed(&rgb1.0, green: &rgb1.1, blue: &rgb1.2, alpha: nil)
        targetColor.getRed(&rgb2.0, green: &rgb2.1, blue: &rgb2.2, alpha: nil)
        
        let r = (rgb1.0 * ratio) + (rgb2.0 * inverseRation)
        let g = (rgb1.1 * ratio) + (rgb2.1 * inverseRation)
        let b = (rgb1.2 * ratio) + (rgb2.2 * inverseRation)
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    public func toImage() -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        if let context: CGContext = UIGraphicsGetCurrentContext() {
            context.setFillColor(self.cgColor)
            context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
            
            let colorImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return colorImage
        }
        
        return nil
    }
}

#if DEBUG
extension UIColor {
    public static var random: UIColor {
        let red = (0...255).randomElement() ?? 255
        let green = (0...255).randomElement() ?? 255
        let blue = (0...255).randomElement() ?? 255
        
        return UIColor(red: CGFloat(red)/CGFloat(255),
                       green: CGFloat(green)/CGFloat(255),
                       blue: CGFloat(blue)/CGFloat(255),
                       alpha: 1)
    }
}
#endif
