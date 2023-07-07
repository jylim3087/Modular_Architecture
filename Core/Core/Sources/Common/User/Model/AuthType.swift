//
//  AuthType.swift
//  DabangSwift
//
//  Created by jiyeonpark on 2023/06/16.
//

import Foundation

enum AuthType: String, Decodable {
    case safe = "SAFE_AUTH"// 본인인증
    case phone = "PHONE_AUTH" // 휴대폰인증
    case none = "NONE" // 미인증
    
    var title: String {
        switch self {
        case .safe:
            return "본인 인증"
        
        case .phone:
            return "휴대폰 인증"
            
        case .none:
            return "미인증"
        }
    }
}
