//
//  FamilyServiceType.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/17.
//

import Foundation
import UIKit

enum FamilyServiceType: CaseIterable {
    case pro
    case hub
    case signWeb
    
    var title: String {
        switch self {
        case .pro: return "다방프로 APP"
        case .hub: return "다방허브 APP"
        case .signWeb: return "다방싸인"
        }
    }
    
    var iconName: String {
        switch self {
        case .pro: return "ic_more_dabang_pro"
        case .hub: return "ic_more_dabang_hub"
        case .signWeb: return "ic_more_dabang_sign"
        }
    }
    
    var url: String? {
        switch self {
        case .pro:
            if let scheme = URL(string: "dabangpro://"), UIApplication.shared.canOpenURL(scheme) == true {
                return "dabangpro://"
            }
            
            return "https://itunes.apple.com/kr/app/id1215588806"
            
        case .hub:
            if let scheme = URL(string: "dabanghouseowner://"), UIApplication.shared.canOpenURL(scheme) == true {
                return "dabanghouseowner://"
            }
            
            return "https://itunes.apple.com/kr/app/id1438069281"
            
        case .signWeb:
            return nil
        }
    }
}
