//
//  LabelProtocol.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2021/04/27.
//

import UIKit
import Then

public protocol LabelComponentable: UILabel {
    var labelFont: UIFont { get }
    var lineSpacing: CGFloat { get }
    var lineHeight: CGFloat { get }
    var verticalPadding: CGFloat { get }
    
    func setStyle()
}

extension LabelComponentable {
    var lineSpacing: CGFloat { 0 }
    
    public func setStyle() {
        self.font = labelFont
        self.textColor = .gray900
    }
}

public protocol AttributeStringApplicable: UILabel {
    func addStyle(_ key: NSAttributedString.Key, _ value: Any)
    func addStyle(_ targetText: String, _ key: NSAttributedString.Key, _ value: Any, _ applyAll: Bool)
}

extension AttributeStringApplicable {
    func addStyle(_ key: NSAttributedString.Key, _ value: Any) {
        guard let attributedText = self.attributedText else { return }
        
        addStyle(attributedText.string, key, value)
    }
    
    public func addStyle(_ targetText: String, _ key: NSAttributedString.Key, _ value: Any, _ applyAll: Bool = false) {
        guard let attributedText = self.attributedText else { return }
        
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        
        if applyAll == true {
            let ranges = ranges(attributedString.string, targetText, [.caseInsensitive])
            
            for range in ranges {
                guard range.location != NSNotFound else { return }
                
                attributedString.addAttribute(key, value: value, range: range)
            }
        }
        else {
            let range = attributedString.mutableString.range(of: targetText, options: .caseInsensitive)
            
            guard range.location != NSNotFound else { return }
            
            attributedString.addAttribute(key, value: value, range: range)
        }
        
        self.attributedText = attributedString
    }
    
    private func ranges(_ baseString: String, _ substring: String, _ options: String.CompareOptions = [], locale: Locale? = nil) -> [NSRange] {
        var ranges: [Range<String.Index>] = []
        
        while let range = baseString.range(of: substring, options: options, range: (ranges.last?.upperBound ?? baseString.startIndex)..<baseString.endIndex, locale: locale) {
            ranges.append(range)
        }
        
        return ranges.map { NSRange($0, in: baseString) }
    }
}

public class ComponentLabel: UILabel, LabelComponentable, AttributeStringApplicable {
    @IBInspectable
    public var labelFont: UIFont { .body1_bold }
    public var lineHeight: CGFloat { 0 }
    public var lineSpacing: CGFloat { 0 }
    public var verticalPadding: CGFloat { 0 }
    public var enabledColor: UIColor = .gray900
    public var disabledColor: UIColor = .gray900
    
    override public var textColor: UIColor! {
        didSet {
            addStyle(.foregroundColor, textColor ?? .gray900)
        }
    }
    
    override public var text: String? {
        didSet {
            guard let text = text else { return }
            
            setDefaultAttirbuteString(text: text, lineSpacing: lineSpacing)
        }
    }
    
    private var paragraphStyle: NSMutableParagraphStyle? {
        guard let attributedText = attributedText else { return nil }
        guard attributedText.string.isEmpty == false else { return nil }
        
        return attributedText.attributes(at: 0, effectiveRange: nil)[.paragraphStyle] as? NSMutableParagraphStyle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setStyle()
    }
    
    override public func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: verticalPadding, left: 0, bottom: verticalPadding, right: 0)
        
        if #available(iOS 13, *) {
            super.drawText(in: rect.inset(by: insets))
            return
        }
        
        let lineCount: Int = {
            let maxNumberOfLine = Int(rect.size.height / lineHeight)
            if numberOfLines == 0 {
                return maxNumberOfLine
            }

            return min(maxNumberOfLine, numberOfLines)
        }()
        
        addParagraphStyle(lineSpacing: (lineCount == 1) ? 0 : lineSpacing)
        
        super.drawText(in: rect.inset(by: insets))
    }

    override public var intrinsicContentSize: CGSize {
        if #available(iOS 13, *) {
            let size = super.intrinsicContentSize
            
            return CGSize(width: size.width, height: size.height + (verticalPadding * 2))
        }
        
//            ios 12 이하.
        
        var size = super.intrinsicContentSize
        let lineCount: Int = {
            let maxNumberOfLine = getLineCount(size.width)
            if numberOfLines == 0 {
                return maxNumberOfLine
            }
            
            return min(maxNumberOfLine, numberOfLines)
        }()
        
        addParagraphStyle(lineSpacing: (lineCount == 1) ? 0 : lineSpacing)
        
        size.height = CGFloat(lineCount) * lineHeight
        
        return size
    }

    override public var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width
        }
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        
        if #available(iOS 13, *) {
            newSize.height += (verticalPadding * 2)
            
            return newSize
        }
        
//            ios 12 이하에서 한글 1줄일 때 라인스페이싱이 있으면 적용되는 버그가 있음.
        
        var paragraphStyleForSize: NSParagraphStyle?
        
        if text?.contains("\t") == true {
            if let paragraphStyle = paragraphStyle {
                paragraphStyleForSize = NSMutableParagraphStyle().then {
                    $0.headIndent = paragraphStyle.headIndent
                    $0.tabStops = paragraphStyle.tabStops
                }
            }
        }
        
        let lineCount: Int = {
            let maxNumberOfLine = getLineCount(newSize.width, paragraphStyleForSize)
            if numberOfLines == 0 {
                return maxNumberOfLine
            }
            
            return min(maxNumberOfLine, numberOfLines)
        }()
        
        newSize.height = CGFloat(lineCount) * lineHeight
        
        return newSize
    }
    
    private func getLineCount(_ width: CGFloat, _ paragraphStyle: NSParagraphStyle? = nil) -> Int {
        let maxSize = CGSize(width: width, height: CGFloat(Float.infinity))
        let text = (text ?? "") as NSString
        var attributes: [NSAttributedString.Key : Any] = [.font: font ?? labelFont]
        if let paragraphStyle = paragraphStyle {
            attributes[.paragraphStyle] = paragraphStyle
        }
        
        let textSize = text.boundingRect(with: maxSize,
                                         options: .usesLineFragmentOrigin,
                                         attributes: attributes,
                                         context: nil)
        
        return Int(ceil(textSize.height / font.lineHeight))
    }
    
    private func paragraphStyle(lineSpacing: CGFloat) -> NSMutableParagraphStyle {
        return NSMutableParagraphStyle().then {
            $0.lineSpacing = lineSpacing
            $0.alignment = textAlignment
            $0.lineBreakMode = lineBreakMode
        }
    }
    
    private func setDefaultAttirbuteString(text: String, lineSpacing: CGFloat = 0) {
        attributedText = NSMutableAttributedString(string: text)
        
        addStyle(.font, font ?? labelFont)
        addStyle(.foregroundColor, textColor ?? .gray900)
        addParagraphStyle(lineSpacing: lineSpacing)
    }
    
    private func addParagraphStyle(lineSpacing: CGFloat) {
        guard let attributedText = attributedText else { return }
        
        if let paragraphStyle = paragraphStyle {
            paragraphStyle.lineSpacing = lineSpacing
            
            addStyle(attributedText.string, .paragraphStyle, paragraphStyle)
        }
        else {
            addStyle(attributedText.string, .paragraphStyle, paragraphStyle(lineSpacing: lineSpacing))
        }
    }
    
    public func addStyle(_ key: NSAttributedString.Key, _ value: Any) {
        guard let attributedText = self.attributedText else { return }
        
        guard key == .paragraphStyle, let newParagraphStyle = value as? NSMutableParagraphStyle else {
            addStyle(attributedText.string, key, value)
            return
        }
        
        if let paragraphStyle = paragraphStyle {
            newParagraphStyle.lineSpacing = paragraphStyle.lineSpacing
        }
        
        addStyle(attributedText.string, key, newParagraphStyle)
    }
}

extension ComponentLabel {
    enum HighlightType {
        case regular
        case medium
        case bold
        
        var fontWeight: UIFont.Weight {
            switch self {
            case .regular: return .regular
            case .medium: return .medium
            case .bold: return .bold
            }
        }
    }
    
    func setHighlight(type: HighlightType? = nil, color: UIColor? = nil, text: String? = nil) {
        if let type = type {
            var descriptor = labelFont.fontDescriptor
            descriptor = descriptor.addingAttributes([UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : type.fontWeight]])
            
            let newFont = UIFont(descriptor: descriptor, size: labelFont.pointSize)
            
            addStyle(text ?? self.text ?? "", .font, newFont)
        }
        
        if let color = color {
            addStyle(text ?? self.text ?? "", .foregroundColor, color)
        }
    }
}
