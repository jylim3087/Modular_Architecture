//
//  WebUI.swift
//  Core
//
//  Created by 임주영 on 2023/07/17.
//

import Foundation

enum WebUI {
    //case map(id: String, type: DetailCommonWebMapType, enterType: DetailCommonWebEnterType)
    //case sign(id: String, type: DetailCommonWebMapType)
    //case school(school: SchoolInfo)
    case postcode
    case report(roomId: String, authKey: String?)
    //case priceHistory(complexId: String, type: SpaceHistoryType, seq: Int)
    case chart(roomId: String)
    //case roomCompare(roomListNodes: [RoomListNode])
    case term(type: TermsType)
    case kakaoBankEvent
    case lottingFaq
    case lottingCalc
    case housingProcess
    case lottingTerms
    case lottingNewsDetail(newsSeq: Int)
}
