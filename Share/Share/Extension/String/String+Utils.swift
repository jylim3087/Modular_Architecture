//
//  String+utils.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 2. 23..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit
import Foundation

extension String {
    static var uniqueId : String {
        let format = "xxxyxxyxxyyxyxxx"
        let result = format.map { (char) -> Character in
            let r = Int(arc4random_uniform(16))
            let v = ( char == "x" ? r : (r&0x3|0x8))
            return String(format: "%X", arguments: [v]).first ?? "0"
        }
        return String(result)
    }
    
    static func uniqueIdWithPrefix(_ prefix:String) -> String {
        return "\(prefix)\(String.uniqueId)"
    }
    
    func textSize(font: UIFont, width: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        let text = self as NSString
        let boundingRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let textBound = text.boundingRect(with: boundingRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return textBound.size
    }
    
    var isEmail: Bool {
        let checkStr = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", checkStr)
        return predicate.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        let checkStr = "(010|011|016|017|018|019)([0-9]{4})([0-9]{4})"
        let predicate = NSPredicate(format:"SELF MATCHES %@", checkStr)
        return predicate.evaluate(with: self)
    }
    
    var hasEmoji: Bool {
        for char in self where char.isEmoji { return true }
        return false
    }
    
    var checkEmptyText: String {
        return self.isEmpty ? "-" : self
    }
    
    var hasEmail: Bool {
        let checkStr = "^.*(" +
            "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
            "\\@" +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
            "(" +
            "\\." +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
            ")+" +
        ").*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", checkStr)
        return predicate.evaluate(with: self)
    }
    
    var hasWebUrl: Bool {
        let checkStr =  "^.*(" +
            "((file|gopher|news|nntp|telnet|https?|ftps?|sftp)://)*([a-z0-9-]+\\.)+[a-z0-9]{2,4}" +
        ").*$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", checkStr)
        return predicate.evaluate(with: self)
    }
    
    var hasPhoneNumber: Bool {
        let checkStr = "^.*(" +
            "(010|011|016|017|018|019)" +
            "(-|\\s)*" +
            "(\\d{3,4})" +
            "(-|\\s)*" +
            "(\\d{4})" +
        ").*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", checkStr)
        return predicate.evaluate(with: self)
    }
    
    var toPhoneNumber: String? {
        if self.count >= 11 {
            return self.replacingOccurrences(of: "(\\d{3})(\\d{4})(\\d+)", with: "$1-$2-$3", options: .regularExpression, range: nil)
        } else if self.count == 10 {
            return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{4})", with: "$1-$2-$3", options: .regularExpression, range: nil)
        } else {
            return self
        }
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    var url : URL? {
        guard let urlString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return URL(string: urlString)
    }
    
    var underLineText : NSMutableAttributedString {
        let textRange = NSRange(0..<self.count)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.fromRed(68, green: 68, blue: 68, alpha: 1.0), range: textRange)
        return attributedText
    }
    
    func underLineText(color: UIColor) -> NSMutableAttributedString {
        let textRange = NSRange(0..<self.count)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: textRange)
        return attributedText
    }
    
    func strikeThrough(color: UIColor) -> NSAttributedString{
        let textRange = NSRange(0..<self.count)
        let attributedString = NSMutableAttributedString(string:self)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughColor,
                                      value: color,
                                      range: textRange)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                      value: 1,
                                      range: textRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: color,
                                      range: textRange)
        return attributedString
    }

    func toDate (format: String = "yyyy-MM-dd HH:mm:ss Z") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func limitDecimal(_ count: Int) -> Bool {
        let checkStr = "[0-9]*+((\\.[0-9]{0,\(count)})?)||(\\.)?"
        let predicate = NSPredicate(format:"SELF MATCHES %@", checkStr)
        return predicate.evaluate(with: self)
    }
    
    func convertDateString(fromFormat sourceFormat : String, toFormat desFormat : String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = sourceFormat
        let date = dateFormatter.date(from: self)
        
        dateFormatter.dateFormat = desFormat
        return dateFormatter.string(from: date ?? Date()).toDate()
    }
    
    var decimalStringToInt : Int? {
        let refinedString = self.components(separatedBy: ",").joined()
        return Int(refinedString)
    }
    
    var decimalStringToInt64 : Int64? {
        let refinedString = self.components(separatedBy: ",").joined()
        return Int64(refinedString)
    }
    
    var isDateString : Bool {
        guard self.count == 8 else { return false }
        let yearIndex = self.index(self.startIndex, offsetBy: 4)
        let monthIndex = self.index(yearIndex, offsetBy: 2)
        let dayIndex = self.index(monthIndex, offsetBy: 2)
        
        guard let year = Int(self[..<yearIndex]), year > 1800 && year < 3000 else { return false }
        guard let month = Int(self[yearIndex..<monthIndex]), month > 0 && month < 13 else { return false }
        guard let day = Int(self[monthIndex..<dayIndex]) else { return false }
        
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return (day > 0 && day < 32)
        case 4, 6, 9, 11:
            return (day > 0 && day < 31)
        case 2:
            return (day > 0 && day < 30)
        default:
            return false
        }
    }
    
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
    
    func hasBanKeyword(keywords: [String]) -> Bool {
        let checkStr = "^.*(" + keywords.joined(separator: "|") + ").*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", checkStr)
        return predicate.evaluate(with: self)
    }
}

extension Character {
    var isEmoji: Bool {
        return Character(UnicodeScalar(UInt32(0x1d000))!) <= self && self <= Character(UnicodeScalar(UInt32(0x1f77f))!)
            || Character(UnicodeScalar(UInt32(0x2100))!) <= self && self <= Character(UnicodeScalar(UInt32(0x26ff))!)
    }
}

typealias RoomExplain = String
extension RoomExplain {
    var hasBanKeyword: Bool {
        let checkStr = "^.*(" +
            "중개수수료|수수료|복비|공짜|무료|반값|원룸텔|셰어|쉐어|메이트|중개료|매매|매도|공동|공용|하메|사무실|작업실|(?i)share|(?i)mate" +
        ").*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", checkStr)
        return predicate.evaluate(with: self)
    }
}
// 정규식 관련 Extension
extension String {
    func findRegex(pattern: String) -> [NSTextCheckingResult]? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        
        return regex.matches(in: self, range: NSRange(location: 0, length: count))
    }
    
    func hasRegex(pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return false
        }
        
        return regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) != nil
    }
}

// 금액값이 "10" 나올 경우 변환
extension String {
    var toManwon: String? {
        return toWon(mininum10000: true)
    }
    
    func toWon(mininum10000: Bool = false) -> String? {
        // mininum10000 최소 단위가 10000원인지 여부
        let tailText = mininum10000 ? "만" : ""
        
        if isEmpty {
            return nil
        }
        
        guard let intValue = Int(self) else {
            return "\(self)\(tailText)원"
        }
        
        if intValue == 0 {
            return "0\(tailText)원"
        }
        
        let units: [Int: String] = {
            if mininum10000 {
                return [10000: "억"]
            }
            
            return [100000000: "억", 10000: "만"]
        }()
        
        var wons = [String]()
        var restValue = intValue
        
        units.forEach { unit, tailText in
            guard restValue > unit else {
                return
            }
            
            let value = restValue / unit // 몫
            restValue -= unit*value // 나머지가 다음 값이 된다
            wons.append("\(value)\(tailText)")
        }
        
        if restValue > 0 {
            wons.append("\(restValue)\(tailText)")
        }
        
        return wons.joined(separator: " ") + "원"
    }
}

extension String {
    func toDouble() -> Double? {
        return Double(self)
    }
}

extension String {
    func toMutableAttributeString() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
}

extension String {
    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func removeAllWhiteSpace() -> String {
        return replacingOccurrences(of: " ", with: "")
    }
}
