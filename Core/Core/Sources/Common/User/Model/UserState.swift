//
//  UserState.swift
//  Core
//
//  Created by 임주영 on 2023/06/30.
//

import Foundation
//
//  UserState.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 2. 1..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit
import Share
import Gloss

enum DataSyncType {
    case none
    case contact
    case favorite
}

// 데이터는 오는 그대로 받고, Datas > Types 의 하위에 값을 정의해서 변경합니다.
struct UserState {
    var email                           : String?
    var name                            : String?
    var nickname                        : String?
    var phone                           : String?
    var tel                             : String?
    var authKey                         : String?
    var userIdx                         : Int?

    var profileUrl                      : String?
    var needRefreshProfile              : Bool      = false

    // 로그인 타입
    var loginType: String? // 레거시
    var joinType: JoinType = .email
    var isSNSUser: Bool {
        return joinType != .email
    }


    // 본인인증 여부
    var isSafeAuth                      : Bool      = false // 레거시
    var authType                        : AuthType = .none

    var isAgent                         : Bool      = false

    var requestId                       : String?   = nil
    var requestReviewId                 : String?   = nil

    var isSignJoin                      : Bool      = false
    var contractInfo                    : ContractModel?

    var existRoom                       : Bool      = false
    var hasPassword                     : Bool      = false
    var isCheckedMarketingTerms         : Bool      = false

    var isRoomMessenger                 : Bool      = false

    var isPhoneNumberCheck              : Bool      = false

    //var marketingAgree : Bool { UserDefaults.standard.bool(forKey: NotificationState.RECEIVE_EVENT_TOPIC_KEY) }

    var loginState                      : LoginState    = .none

    var hasFavoriteRoomFilters          : Bool      = false

    var delegateSyncType: DataSyncType = .none
}

extension UserState: Decodable {
    private enum CodingKeys: String, CodingKey {
        case email                      = "email"
        case authKey                    = "auth_key"
        case phone                      = "phone"
        case tel                        = "tel"
        case name                       = "name"
        case nickname                   = "nickname"
        case profileUrl                 = "profile_url"

        case loginType                  = "login_type"
        case joinType                   = "join_type"

        case isSafeAuth                 = "is_safe_auth"
        case authType                   = "auth_type"

        case isAgent                    = "is_agent"
        case existRoom                  = "exist_room"
        case hasPassword                = "has_password"
        case isCheckedMarketingTerms    = "is_checked_marketing_terms"
        case isAgreeMarketingTerms      = "is_agree_marketing_terms"
        case hasFavoriteRoomFilters     = "has_favorite_room_filters"
        case isSignJoin                 = "is_sign_join"
        case userIdx                    = "user_idx"
        case contractInfo               = "contract_info"
        case isPhoneNumberCheck         = "is_phone_number_check"
        case isRoomMessenger            = "is_room_messenger"
    }

    init(from decoder: Swift.Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.authKey = try container.decodeIfPresent(String.self, forKey: .authKey)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.tel = try container.decodeIfPresent(String.self, forKey: .tel)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
        self.profileUrl = try container.decodeIfPresent(String.self, forKey: .profileUrl)

        let loginType = try container.decodeIfPresent(String.self, forKey: .loginType)
        self.loginType = loginType
        self.joinType = try {
            if let tmp = try container.decodeIfPresent(JoinType.self, forKey: .joinType) {
                return tmp
            }

            return loginType == "sns" ? .kakao : .email
        }()

        let isSafeAuth = try container.decodeIfPresent(Bool.self, forKey: .isSafeAuth) ?? false
        self.isSafeAuth = isSafeAuth
        self.authType = try {
            if let tmp = try container.decodeIfPresent(AuthType.self, forKey: .authType) {
                return tmp
            }

            return isSafeAuth ? .safe : .none
        }()

        self.isAgent = try container.decodeIfPresent(Bool.self, forKey: .isAgent) ?? false
        self.existRoom = try container.decodeIfPresent(Bool.self, forKey: .existRoom) ?? false
        self.hasPassword = try container.decodeIfPresent(Bool.self, forKey: .hasPassword) ?? false
        self.isCheckedMarketingTerms = try container.decodeIfPresent(Bool.self, forKey: .isCheckedMarketingTerms) ?? false
        self.hasFavoriteRoomFilters = try container.decodeIfPresent(Bool.self, forKey: .hasFavoriteRoomFilters) ?? false
        self.isSignJoin = try container.decodeIfPresent(Bool.self, forKey: .isSignJoin) ?? false
        self.userIdx = try container.decodeIfPresent(Int.self, forKey: .userIdx) ?? -1
        self.contractInfo = try container.decodeIfPresent(ContractModel.self, forKey: .contractInfo)
        self.isPhoneNumberCheck = try container.decodeIfPresent(Bool.self, forKey: .isPhoneNumberCheck) ?? false
        self.isRoomMessenger = try container.decodeIfPresent(Bool.self, forKey: .isRoomMessenger) ?? false

//        if authKey != nil {
//            let marketingAgree = try container.decodeIfPresent(Bool.self, forKey: .isAgreeMarketingTerms) ?? false
//            UserDefaults.standard.set(marketingAgree, forKey: NotificationState.RECEIVE_EVENT_TOPIC_KEY)
//        }
//
//        delegateSyncType = appStore.state.user.delegateSyncType
    }
}

extension UserState : JSONDecodable {
    init?(json: JSON) {
        self.email                      = ("email"                          <~~ json)
        self.authKey                    = ("auth_key"                       <~~ json)
        self.phone                      = ("phone"                          <~~ json)
        self.tel                        = ("tel"                            <~~ json)
        self.name                       = ("name"                           <~~ json)
        self.nickname                   = ("nickname"                       <~~ json)
        self.profileUrl                 = ("profile_url"                    <~~ json)

        let loginType: String? = ("login_type" <~~ json)
        self.loginType = loginType
        self.joinType = {
            if let tmp: JoinType = ("join_type" <~~ json) {
                return tmp
            }

            return loginType == "sns" ? .kakao : .email
        }()

        let isSafeAuth: Bool = ("is_safe_auth" <~~ json) ?? false
        self.isSafeAuth = isSafeAuth
        self.authType = {
            if let tmp: AuthType = ("auth_type" <~~ json) {
                return tmp
            }

            return isSafeAuth ? .safe : .none
        }()

        self.isAgent                    = ("is_agent"                       <~~ json) ?? false
        self.existRoom                  = ("exist_room"                     <~~ json) ?? false
        self.hasPassword                = ("has_password"                   <~~ json) ?? false
        self.isCheckedMarketingTerms    = ("is_checked_marketing_terms"     <~~ json) ?? false
        self.hasFavoriteRoomFilters     = ("has_favorite_room_filters"      <~~ json) ?? false
        self.isSignJoin                 = ("is_sign_join"                   <~~ json) ?? false
        self.userIdx                    = ("user_idx"                       <~~ json) ?? -1

        self.contractInfo               = ("contract_info"                  <~~ json)

        self.isPhoneNumberCheck         = ("is_phone_number_check"          <~~ json) ?? false
        self.isRoomMessenger            = ("is_room_messenger"              <~~ json) ?? false

        if authKey != nil {
            let marketingAgree = ("is_agree_marketing_terms"       <~~ json) ?? false
            //UserDefaults.standard.set(marketingAgree, forKey: NotificationState.RECEIVE_EVENT_TOPIC_KEY)
        }

        //delegateSyncType = appStore.state.user.delegateSyncType
    }

    var jsonDic : [String:Any] {
        var resultDic = [String:Any]()
        if let email = self.email {
            resultDic.updateValue(email, forKey: "email")
        }
        if let authKey = self.authKey {
            resultDic.updateValue(authKey, forKey: "auth_key")
        }
        if let phone = self.phone {
            resultDic.updateValue(phone, forKey:"phone")
        }
        if let name = self.name {
            resultDic.updateValue(name, forKey:"name")
        }
        if let nickname = self.nickname {
            resultDic.updateValue(nickname, forKey:"nickname")
        }
        if let userIdx = self.userIdx {
            resultDic.updateValue(userIdx, forKey:"userIdx")
        }

        return resultDic
    }

    var isLogin : Bool {
        return (self.authKey != nil)
    }
}

// MARK: Kakao Login
struct KakaoLoginInfo {
    var phone       : String?
    var name        : String?
    var auth_key    : String?
    var email       : String?
}

//extension KakaoLoginInfo : JSONDecodable {
//    init?(json:JSON) {
//        self.phone = ("phone"       <~~ json) ?? ""
//        self.name = ("name"       <~~ json) ?? ""
//        self.auth_key = ("auth_key"       <~~ json) ?? ""
//        self.email = ("email"       <~~ json) ?? ""
//    }
//}


// MARK: Facebook Login
struct FbLoginInfo {
    var phone       : String?
    var name        : String?
    var auth_key    : String?
    var email       : String?
}

//extension FbLoginInfo : JSONDecodable {
//    init?(json:JSON) {
//        self.phone = ("phone"       <~~ json) ?? ""
//        self.name = ("name"       <~~ json) ?? ""
//        self.auth_key = ("auth_key"       <~~ json) ?? ""
//        self.email = ("email"       <~~ json) ?? ""
//    }
//}
