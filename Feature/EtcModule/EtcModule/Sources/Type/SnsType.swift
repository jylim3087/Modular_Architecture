//
//  SnsType.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/17.
//

import Foundation

enum SnsType: CaseIterable {
    case instagram
    case facebook
    case naverblog
    case naverpost
    case youtube
    
    var title: String {
        switch self {
        case .instagram: return "인스타그램"
        case .facebook: return "페이스북"
        case .naverblog: return "네이버 블로그"
        case .naverpost: return "네이버 포스트"
        case .youtube: return "유튜브"
        }
    }
    
    var iconName: String {
        switch self {
        case .instagram: return "ic_32_sns_instagram_enabled"
        case .facebook: return "ic_32_sns_facebook_enabled"
        case .naverblog: return "ic_32_sns_blog_01_enabled"
        case .naverpost: return "ic_32_sns_blog_02_enabled"
        case .youtube: return "ic_32_sns_youtube_enabled"
        }
    }
    
    var url: String {
        switch self {
        case .instagram: return "https://www.instagram.com/dabang_app"
        case .facebook: return "https://www.facebook.com/dabangapp"
        case .naverblog: return "https://blog.naver.com/station3inc"
        case .naverpost: return "http://m.post.naver.com/station3inc"
        case .youtube: return "https://www.youtube.com/user/DabangApp"
        }
    }
}
