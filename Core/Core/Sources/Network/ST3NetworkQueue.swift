//
//  ST3Networking.swift
//  DabangSwift
//
//  Created by ryuickhwan on 2019/09/23.
//  Copyright © 2019 young-soo park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

enum NetworkingState {
    case progress
    case complete
}

private let didResume = Request.didResumeNotification //Notification.Name.Task.DidResume
private let didComplete = Request.didFinishNotification
private let didSuspend = Request.didSuspendNotification
private let didCancel = Request.didCancelNotification

class ST3NetworkQueue {
    
    private static var sharedInstence = ST3NetworkQueue()
    private var queue = BehaviorRelay<Int>(value: 0)
    var state = PublishSubject<NetworkingState>()
    
    var disposeBag = DisposeBag()
    
    static func shared() -> ST3NetworkQueue {
        return ST3NetworkQueue.sharedInstence
    }
    
    init() {
        let center = NotificationCenter.default.rx
        
        Observable.merge([center.notification(didResume), center.notification(didComplete),
                          center.notification(didSuspend), center.notification(didCancel)])
            .map { $0.name == didResume ? .progress : .complete }
            .do(onNext: { [weak self] state in
                guard let self = self else { return }
                if state == .progress {
                    self.queue.accept(max(0, self.queue.value + 1))
                }else {
                    self.queue.accept(max(0, self.queue.value - 1))
                }
            })
            .bind(to: state)
            .disposed(by: disposeBag)
        
        queue.map { $0 != 0 }
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}
