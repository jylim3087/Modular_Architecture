//
//  EtcMainViewReactor.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/17.
//

import Foundation
import Share
import RxSwift
import ReactorKit

public final class EtcMainViewReactor: Reactor {
    
    public enum Action {
       case tapMainEvent(MainMenuType)
    }
    
    public enum Mutation {
        case tapMainEvent(MainMenuType)
    }
    
    public struct State {
        var mainMenuAction: MainMenuType?
    }
    
    public var initialState: State

    public init() {
        initialState = State()
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapMainEvent(let menu):
            return .just(.tapMainEvent(menu))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        state.mainMenuAction = nil
        
        switch mutation {
        case .tapMainEvent(let mainMenuAction):
            state.mainMenuAction = mainMenuAction
        }
        
        return state
    }
}
