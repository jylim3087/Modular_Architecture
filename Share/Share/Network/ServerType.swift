//
//  ServerType.swift
//  DabangSwift
//
//  Created by R.I.H on 09/04/2019.
//  Copyright © 2019 young-soo park. All rights reserved.
//
public enum ST3Server: Int {
    case test       = 0
    case sinhanTest = 1
    case staging    = 2
    case release    = 3
}

extension ST3Server: CaseIterable {
    public var title: String {
        switch self {
        case .sinhanTest:
            return "신한테스트"
        case .test:
            return "테스트"
        case .staging:
            return "스테이징"
        case .release:
            return "릴리즈"
        }
    }
    
    public var url: String {
        switch self {
        case .sinhanTest:
            return "https://standby-dabang-main.dabangapp.com"
        case .test:
            return "https://test-dabang-main.dabangapp.com"
        case .staging:
            return "https://staging-dabang-main.dabangapp.com"
        case .release:
            return "https://api-dabang2.dabangapp.com"
        }
    }
    
    public var web: String {
        switch self {
        case .sinhanTest:
            return "https://standby-dabang-main.dabangapp.com"
        case .test:
            return "http://test-dabang-web.dabangapp.com"
        case .staging:
            return "https://staging-dabang-web.dabangapp.com"
        case .release:
            return "https://www.dabangapp.com"
        }
    }
}
