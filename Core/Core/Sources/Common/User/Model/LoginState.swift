//
//  LoginState.swift
//  Core
//
//  Created by 임주영 on 2023/07/03.
//

enum LoginState: Equatable {
    case none
    case user(name: String?, imagePathType: ImagePathType?)
    case agent(name: String?, email: String?, imagePathType: ImagePathType?)
    
    var isLogin: Bool { self != .none }
    
    var isAgent: Bool {
        switch self {
        case .agent: return true
        default: return false
        }
    }
}
