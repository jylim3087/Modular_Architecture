//
//  ST3NetworkExtension.swift
//  DabangSwift
//
//  Created by ryuickhwan on 2019/12/23.
//  Copyright © 2019 young-soo park. All rights reserved.
//

import Alamofire
import RxSwift
import RxCocoa
import Share

extension Result {
    var httpErrorCode: Int? {
        switch self {
        case .failure(let error):
            return error._code
        default:
            return nil
        }
    }
}

extension PrimitiveSequence {
    func retryWhen() -> PrimitiveSequence<SingleTrait, Element> {
        return self.retry { errorObservable -> Observable<Void> in
            let errorObs = errorObservable.map { error -> Error in
                if let dbError = error as? DBErrors, dbError.needRetry {
                    return error
                }
                throw error
            }
            
            let interval = Observable<Int>
                .interval(.milliseconds(100), scheduler: MainScheduler.asyncInstance)
            
            return Observable
                .zip(errorObs, interval, resultSelector: { error, interval in
                    DBLog("RetryWhen: \(error) \(interval)")
                    if interval >= 2 { throw error }
                    return ()
                })
        } as! PrimitiveSequence<SingleTrait, Element>
    }
}
