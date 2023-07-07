//
//  LoginType.swift
//  Core
//
//  Created by 임주영 on 2023/06/30.
//

import Foundation
import UIKit

enum LoginType: Int {
    case email = 101
    case kakao
    case apple
    case facebook
}

extension LoginType {
    
    var title: String? {
        switch self {
        case .email: return "이메일로 로그인하기"
        case .kakao: return "카카오로 바로 시작"
        case .apple: return "Apple로 계속하기"
        default: return nil
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .email: return UIImage(named: "ic_24_email_at")
        case .kakao: return UIImage(named: "ic_24_kakao_logo")
        case .apple: return UIImage(named: "ic_24_apple_logo")
        case .facebook: return UIImage(named: "ic_44_sns_facebook")
        }
    }
    
    var leftMargin: CGFloat {
        switch self {
        case .facebook: return 0
        default: return 12
        }
    }
    
    var textColor: UIColor? {
        switch self {
        case .email: return .gray900
        case .kakao: return .fromRGBString(hexString: "#381E1F")
        case .apple: return .white0
        case .facebook: return nil
        }
    }
    
    var font: UIFont? {
        switch self {
        case .apple:
            return .systemFont(ofSize: 14, weight: .semibold)
        default:
            return .body3_bold
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .email: return .white0
        case .kakao: return .fromRGBString(hexString: "FEE500")
        case .apple: return .black0
        case .facebook: return .fromRGBString(hexString: "3875EA")
        }
    }
    
    var borderColor: UIColor? {
        switch self {
        case .email: return .fromRGBString(hexString: "DFDFDF")
        default: return nil
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .email, .kakao, .apple: return 6
        case .facebook: return 22
        }
    }
}
