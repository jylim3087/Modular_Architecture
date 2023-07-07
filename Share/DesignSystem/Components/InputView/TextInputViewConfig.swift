//
//  TextInputViewConfig.swift
//  test
//
//  Created by Ickhwan Ryu on 2021/07/16.
//

import UIKit

public struct TextInputViewConfig<T: TextInputValidatorType> {
    public enum FieldType: Equatable {
        case textfield(left: UIView?, right: UIView?)
        case textview(ratio: CGFloat)
        
        enum InnerType {
            case textfield
            case textview
        }
        
        static func == (lhs: Self, rhs: InnerType) -> Bool {
            switch lhs {
            case .textfield:
                return rhs == .textfield
                
            case .textview:
                return rhs == .textview
            }
        }
    }
    
    public var type: FieldType
    public var title: String
    public var helpText: String
    public var placeHolder: String
    public var maxLength: Int?
    public var inputRegExp: String?
    public var keyboardType: UIKeyboardType
    public var secureTextEntry: Bool
    public var enabled: TextInputViewState // 초기 상태 지정
    public var isRequired: Bool // 타이틀옆 별모양 표기 여부
    public var isErrorStateManaging: Bool // 에러 상태관리 셀프처리 여부
    public var needDoneToolbar: Bool
    public var validator: T?
    public var validType: T.ValidType?
    public var showCount: Bool // TextView 타입일경우 Count 표시
    
    
    init(type: FieldType,
         title: String = "",
         helpText: String = "",
         placeHolder: String = "",
         maxLength: Int? = nil,
         inputRegExp: String? = nil,
         keyboardType: UIKeyboardType = .default,
         secureTextEntry: Bool = false,
         enabled: TextInputViewState = .enabled,
         isRequired: Bool = false,
         isErrorStateManaging: Bool = true,
         needDoneToolbar: Bool = false,
         validator: T? = nil,
         validType: T.ValidType? = nil,
         showCount: Bool = false
    ) {
        self.type = type
        self.title = title
        self.helpText = helpText
        self.placeHolder = placeHolder
        self.maxLength = maxLength
        self.inputRegExp = inputRegExp
        self.keyboardType = keyboardType
        self.secureTextEntry = secureTextEntry
        self.enabled = enabled
        self.isRequired = isRequired
        self.isErrorStateManaging = isErrorStateManaging
        self.needDoneToolbar = needDoneToolbar
        self.validType = validType
        self.showCount = showCount
    }
}

public enum TextInputViewState {
    case enabled
    case focus
    case disable
    case error
    
    var backgroundColor: UIColor {
        switch self {
        case .disable: return .gray50
        default: return .white0
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .enabled, .disable: return .gray300
        case .focus: return .gray900
        case .error: return .red500
        }
    }
    
    var alarmTextColor: UIColor {
        switch self {
        case .enabled, .focus: return .gray800
        case .disable: return .gray500
        case .error: return .red500
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .enabled: return .gray900
        case .disable: return .gray500
        default: return .gray900
        }
    }
    
    var placeholderColor: UIColor {
        switch self {
        case .disable: return .gray500
        default: return .gray600
        }
    }
}
