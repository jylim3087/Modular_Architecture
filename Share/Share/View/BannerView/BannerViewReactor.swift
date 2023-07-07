//
//  SignDetailBannerViewReactor.swift
//  DabangSwift
//
//  Created by 조동현 on 2022/03/21.
//

import ReactorKit
import Foundation

enum WebViewOpenType: Int, Decodable {
    case inApp = 0
    case external
    
    init(from decoder: Swift.Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let rawValue = try? container.decode(Int.self) {
            switch rawValue {
            case 0: self    = .inApp
            case 1: self    = .external
            default: self = .inApp
            }
            return
        }
        
        if let rawValue = try? container.decode(String.self) {
            switch rawValue {
            case "IN_APP": self = .inApp
            case "EXTERNAL": self = .external
            default:
                self = .inApp
            }
            return
        }
        fatalError()
    }
}

enum ImagePathType: Equatable {
    case url(with: String)
    case asset(name: String)
}

protocol BannerProtocol {
    var imagePathType: ImagePathType { get }
    var url: String { get }
    var openType: WebViewOpenType { get }
    var title: String? { get }
    var loginRequire: Bool { get }
}

struct BannerModel: BannerProtocol {
    var imagePathType: ImagePathType
    var url: String
    var openType: WebViewOpenType = .inApp
    var title: String?
    var loginRequire: Bool = false
}

final class BannerViewReactor: Reactor {
    enum Action {
        case setBanner(models: [BannerProtocol])
        case detail(Int)
        case didShow(at: Int)
    }
    
    enum Mutation {
        case banner([BannerProtocol])
        case detail(BannerProtocol)
        case didShow(Int)
        
        var bindMutation: BindMutation {
            switch self {
            case .banner: return .banner
            case .detail: return .detail
            default: return .initialState
            }
        }
    }
    
    enum BindMutation {
        case initialState
        case banner
        case detail
    }
    
    struct State {
        var state: BindMutation = .initialState
        
        let ratioType: BannerRatioType
        var models: [BannerProtocol] = []
        
        var detailModel: BannerProtocol?
        var currentIndex = 0
    }
    
    var initialState: State
    
    init(bannerModels: [BannerProtocol]? = nil, ratioType: BannerRatioType) {
        initialState = State(ratioType: ratioType)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setBanner(let models):
            return .just(.banner(models))
            
        case .detail(let index):
            if let model = currentState.models[safe: index] {
                return .just(.detail(model))
            }
            
            return .empty()
            
        case .didShow(let index):
            return .just(.didShow(index))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        state.state = mutation.bindMutation
        
        switch mutation {
        case .banner(let models):
            state.models = models
            
        case .detail(let model):
            state.detailModel = model
            
        case .didShow(let index):
            state.currentIndex = index
        }
        
        return state
    }
}
