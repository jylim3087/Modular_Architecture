//
//  EtcUserInfoViewReactor.swift
//  EtcModule
//
//  Created by 임주영 on 2023/06/30.
//

import Foundation
import ReactorKit
import Share

final class EtcUserInfoViewReactor: Reactor {
    enum Action {
        case user(state: UserState)
        case userAction
    }
    
    enum Mutation {
        case loginState(LoginState)
        case action(EtcActionType.UserInfoAction)
        
        var bindMutation: BindMutation {
            switch self {
            case .loginState: return .userState
            default: return .initialState
            }
        }
    }
    
    enum BindMutation {
        case initialState
        case userState
    }
    
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
    
    struct State {
        var state: BindMutation = .initialState
        
        var loginState: LoginState = .none
        var userInfoAction: EtcActionType.UserInfoAction?
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .user(let userState):
            guard userState.authKey != nil else {
                return .just(.loginState(.none))
            }
            
            let loginStateObservable: Observable<Mutation> = userState.isAgent == false
            ? .just(.loginState(.user(name: userState.nickname, imagePathType: userState.profileUrl == nil ? nil : .url(with: userState.profileUrl!))))
            : .just(.loginState(.agent(name: userState.name, email: userState.email, imagePathType: userState.profileUrl == nil ? nil : .url(with: userState.profileUrl!))))
            
            return loginStateObservable
            
        case .userAction:
            switch currentState.loginState {
            case .none:
                return .just(.action(.login))
                
            case .user:
                return .just(.action(.edit))
                
            case .agent:
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        state.state = mutation.bindMutation
        
        state.userInfoAction = nil
        
        switch mutation {
        case .loginState(let loginState):
            state.loginState = loginState
            
        case .action(let action):
            state.userInfoAction = action
        }
        
        return state
    }
}
