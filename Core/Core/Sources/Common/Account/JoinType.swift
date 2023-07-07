//
//  JoinType.swift
//  DabangSwift
//
//  Created by jiyeonpark on 2023/06/16.
//

import Foundation

enum JoinType: String, Decodable {
    case email = "email"
    case kakao = "kakao"
    case facebook = "facebook"
    case apple = "apple"
    
    var iconName: String {
        switch self {
        case .email:
            return "ic_24_ellipse_email"
            
        case .kakao:
            return "ic_24_sns_kakao"
            
        case .facebook:
            return "ic_24_sns_facebook"
            
        case .apple:
            return "ic_24_sns_apple"
        }
    }
    
    var loginType: LoginType {
        switch self {
        case .email: return .email
        case .apple: return .apple
        case .kakao: return .kakao
        case .facebook: return .facebook
        }
    }
}

enum JoinReqType {
    case email
    case apple(token: String)
    case kakao(token: String)
    case facebook(token: String)
}
