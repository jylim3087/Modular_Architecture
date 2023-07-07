//
//  PagerStepper.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/23.
//

import RxSwift
import RxCocoa

public protocol PagerStepper {
    var steps: PublishSubject<PagerStep> { get }
    var initialStep: PagerStep { get }
}

extension PagerStepper {
    public var initialStep: PagerStep {
        return NonePagerStep()
    }
}
