//
//  TermActionType.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/17.
//

import Foundation
import Core

enum TermActionType: CaseIterable {
    case policy
    case `private`
    case company
    
    var title: String {
        switch self {
        case .policy: return TermsType.termsOfService.title
        case .private: return TermsType.privacy.title
        case .company: return "회사소개"
        }
    }
    
    var url: String {
        switch self {
        case .policy: return ""//WebUI.term(type: .termsOfService).url
        case .private: return ""//WebUI.term(type: .privacy).url
        case .company: return "http://station3.co.kr"
        }
    }
}
