//
//  TermsType.swift
//  Core
//
//  Created by 임주영 on 2023/07/17.
//

import Foundation

public enum TermsType: Int {
    case termsOfServiceJoin = -1
    case termsOfService = 0
    case privacy
    case telecom_privacy
    case telecom_uniqueNum
    case telecom_termsOfTelecom
    case telecom_termsOfService
    case telecom_provision3Party
    
    static var baseUrl: String { ST3TermsServerPath }
    
    public var path: String {
        switch self {
        case .termsOfServiceJoin:
            return "/terms/common/terms-of-service"
            
        case .termsOfService:
            return "/terms/common/terms-of-service?only=true"
            
        case .privacy:
            return "/terms/dabang/collecting-use-personal"
            
        case .telecom_privacy:
            return "/terms/telecom/collecting-use-personal"
            
        case .telecom_uniqueNum:
            return "/terms/telecom/unique-number"
            
        case .telecom_termsOfTelecom:
            return "/terms/telecom/terms-of-telecom"
            
        case .telecom_termsOfService:
            return "/terms/telecom/terms-of-service"
            
        case .telecom_provision3Party:
            return "/terms/telecom/provision-third-party"
        }
    }
    
    public var title: String {
        switch self {
        case .termsOfServiceJoin:
            return "이용약관"
            
        case .termsOfService:
            return "이용약관"
            
        case .privacy:
            return "개인정보 처리방침"
            
        case .telecom_privacy:
            return "개인정보 수집/이용 동의"
            
        case .telecom_uniqueNum:
            return "고유식별정보 처리 동의"
            
        case .telecom_termsOfTelecom:
            return "통신사 이용약관 동의"
            
        case .telecom_termsOfService:
            return "서비스 이용약관 동의"
            
        case .telecom_provision3Party:
            return "개인정보 제 3자 이용동의"
        }
    }
}
