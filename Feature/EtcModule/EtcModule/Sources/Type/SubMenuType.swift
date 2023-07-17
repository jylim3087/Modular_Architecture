//
//  SubMenuType.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/17.
//

import Foundation

public enum SubMenuType: CaseIterable {
    case event
    case registerRoom
    case fakeRoomReportList
    
    var title: String {
        switch self  {
        case .event:
            return "이벤트"
        case .registerRoom:
            return "방 내놓기"
        case .fakeRoomReportList:
            return "허위매물 신고 내역"
        }
    }
}
