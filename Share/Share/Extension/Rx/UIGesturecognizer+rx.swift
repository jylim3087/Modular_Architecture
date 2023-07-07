//
//  UIGesture+Rx.swift
//  DabangSwift
//
//  Created by R.I.H on 18/04/2019.
//  Copyright © 2019 young-soo park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias View = UIView
typealias Gesture = UIGestureRecognizer
typealias State = UIGestureRecognizer.State

enum GestureType {
    case pan(_ when: [State])
    case tap(_ when: [State])
    case swipe(_ when: [State])
}
extension GestureType {
    var gesture: Gesture {
        switch self {
        case .pan:
            return UIPanGestureRecognizer()
        case .tap:
            return UITapGestureRecognizer()
        case .swipe:
            return UISwipeGestureRecognizer()
        }
    }
    var state: [State] {
        switch self {
        case .tap(let when), .pan(let when), .swipe(let when):
            return when
        }
    }
}
extension Reactive where Base: View {
    internal func tapGesture(_ when: State..., config: ((UITapGestureRecognizer)->())? = nil) -> Observable<UITapGestureRecognizer> {
        let tapGesture = UITapGestureRecognizer()
        config?(tapGesture)
        return self.gesture(gesture: tapGesture, when: when).map { $0 as! UITapGestureRecognizer }
    }
    internal func panGesture(_ when: State..., config: ((UIPanGestureRecognizer)->())? = nil) -> Observable<UIPanGestureRecognizer> {
        let tapGesture = UIPanGestureRecognizer()
        config?(tapGesture)
        return self.gesture(gesture: tapGesture, when: when).map { $0 as! UIPanGestureRecognizer }
    }
    internal func swipeGesture(_ when: State..., config: ((UISwipeGestureRecognizer)->())? = nil) -> Observable<UISwipeGestureRecognizer> {
        let tapGesture = UISwipeGestureRecognizer()
        config?(tapGesture)
        return self.gesture(gesture: tapGesture, when: when).map { $0 as! UISwipeGestureRecognizer }
    }
    internal func anyGesture(_ gestures: GestureType...) -> ControlEvent<UIGestureRecognizer> {
        let observables = gestures.map { gesture -> Observable<UIGestureRecognizer> in
            return self.gesture(gesture: gesture.gesture, when: gesture.state).asObservable() as Observable<UIGestureRecognizer>
        }
        let source = Observable.from(observables).merge()
        return ControlEvent(events: source)
    }
    fileprivate func gesture(gesture: Gesture, when: [State]) -> Observable<UIGestureRecognizer> {
        let source = Observable.deferred { [weak control = self.base] () -> Observable<UIGestureRecognizer> in
            MainScheduler.ensureExecutingOnScheduler()
            guard let control = control else { return .empty() }
            control.isUserInteractionEnabled = true
            control.addGestureRecognizer(gesture)
            return gesture.rx.event
                .startWith(gesture)
                .do(onDispose: { [weak control, weak gesture] () in
                    guard let gesture = gesture else { return }
                    control?.removeGestureRecognizer(gesture)
                })
                .take(until: control.rx.deallocated)
        }
        var gestureObservable : Observable<UIGestureRecognizer>
        gestureObservable = ControlEvent(events: source).filter { gesture in
            return when.contains(gesture.state)
        }
        return gestureObservable
    }
}
