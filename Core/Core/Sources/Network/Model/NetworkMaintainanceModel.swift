//
//  NetworkMaintainanceModel.swift
//  Core
//
//  Created by 임주영 on 2023/07/07.
//

import Foundation

struct NetworkMaintainanceModel: Decodable {
    var title: String?
    var contents: String?
    var inspectionDate: String?
    var inspectionMsg: String?
    
    private enum CodingKeys: String, CodingKey {
        case title, contents
        case inspectionDate = "inspection_date"
        case inspectionMsg = "inspection_msg"
    }
}
