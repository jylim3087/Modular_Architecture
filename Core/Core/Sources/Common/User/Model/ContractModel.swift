//
//  ContractModel.swift
//  Core
//
//  Created by 임주영 on 2023/07/03.
//

import Foundation
import Gloss

enum ContractStatus: String, Decodable {
    case availableRequest = "AVAILABLE_REQUEST"
    case inRequest = "IN_REQUEST"
    case inContract = "IN_CONTRACT"
    
    var title: String {
        switch self {
        case .availableRequest:
            return "예상비용 알아보기"
            
        case .inRequest:
            return "MY계약 요청보기"
            
        case .inContract:
            return "MY계약 진행보기"
        }
    }
    
    var iconName: String {
        switch self {
        case .availableRequest:
            return "ic_20_cash_pink500"
            
        case .inRequest:
            return "ic_20_document_pink500"
            
        case .inContract:
            return "ic_20_receipt_pink500"
        }
    }
}

struct ContractModel: Decodable {
    let signUrl: String
    let status: ContractStatus
    
    enum CodingKeys: String, CodingKey {
        case signUrl = "sign_url"
        case status = "contract_status"
    }
}

extension ContractModel: JSONDecodable {
    init?(json: JSON) {
        self.signUrl = ("sign_url" <~~ json) ?? ""
        self.status = ("contract_status" <~~ json) ?? .availableRequest
    }
}
