//
//  Observable+Extension.swift
//  Share
//
//  Created by 임주영 on 2023/07/03.
//

import Foundation
import RxSwift

extension ObservableType {
    public func bindOnMain(onNext: @escaping (Self.Element) -> Swift.Void) -> Disposable {
        return self.onMain().bind(onNext: onNext)
    }
    
    public func onMain() -> RxSwift.Observable<Self.Element> {
        return self.observe(on: MainScheduler.instance)
    }
}
