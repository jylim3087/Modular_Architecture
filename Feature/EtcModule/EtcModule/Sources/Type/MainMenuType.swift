//
//  MainMenuType.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/14.
//

import Foundation
import UIKit

public enum MainMenuType: CaseIterable {
    case contactRoom
    case untactContract
    case customerService
    
    var iconName: String {
        switch self {
        case .contactRoom:
            return "ic_32_morepage_inquire_room"
        case .untactContract:
            return "ic_32_morepage_dabang_sign"
        case .customerService:
            return "ic_32_moreoage_customer_service"
        }
    }
    
    var title: String {
        switch self {
        case .contactRoom:
            return "문의한 방"
        case .untactContract:
            return "MY 비대면 계약"
        case .customerService:
            return "고객센터"
        }
    }
}
