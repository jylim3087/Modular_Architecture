//
//  NetworkManager.swift
//  DabangSwift
//
//  Created by Ickhwan Ryu on 2020/09/15.
//  Copyright © 2020 young-soo park. All rights reserved.
//

import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let reachability = NetworkReachabilityManager()
    
    func startListening() {
        reachability?.startListening(onUpdatePerforming: { status in
            switch status {
            case .notReachable:
                print("**** notReachable")
            case .unknown:
                print("**** unknown")
            case .reachable:
                print("**** reachable")
            }
        })
    }
}
