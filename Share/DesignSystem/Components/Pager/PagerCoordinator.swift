//
//  PagerCoordinator.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/23.
//

import UIKit
import RxSwift
import RxCocoa

public final class PagerCoordinator: NSObject {
    
    // MARK: - Property
    
    public var rootView: UIView? { flow?.root.view }
    
    public var currentStep = BehaviorRelay<PagerStep>(value: NonePagerStep())
    public var currentPagerVC = PublishSubject<PagerContentComponentable?>()
    
    private var disposeBag = DisposeBag()
    
    private var flow: PagerFlow?
    private var stepper: PagerStepper?
    
    private weak var pagerMain: PagerMainComponentable?
    
    private var moveToRelay = PublishRelay<PagerStep>()
    private var pagerDataRelay = PublishRelay<PagerData?>()
    
    init(pagerMain: PagerMainComponentable? = nil) {
        self.pagerMain = pagerMain
        
        if let pagerMain = pagerMain {
            moveToRelay
                .observe(on: MainScheduler.asyncInstance)
                .bind(to: pagerMain.moveTo)
                .disposed(by: disposeBag)

            pagerDataRelay
                .observe(on: MainScheduler.asyncInstance)
                .bind(to: pagerMain.pagerData)
                .disposed(by: disposeBag)
        }
    }
    
    public func coordinate(flow: PagerFlow, stepper: PagerStepper) {
        self.flow = flow
        self.stepper = stepper
        
        stepper.steps
            .scan(NonePagerStep() , accumulator: { [weak self] (current, step) in
                switch flow.navigate(step) {
                case .navigation(let vc, let animated):
                    guard let vc = vc else { return current }
                    
                    if let self = self {
                        vc.moveTo
                            .observe(on: MainScheduler.asyncInstance)
                            .bind(to: self.moveToRelay)
                            .disposed(by: self.disposeBag)

                        vc.pagerData
                            .observe(on: MainScheduler.asyncInstance)
                            .bind(to: self.pagerDataRelay)
                            .disposed(by: self.disposeBag)
                        
                        self.currentPagerVC.onNext(vc)
                    }
                    
                    let animated = current.index != step.index ? animated : false
                    flow.root.setViewControllers([vc], direction: current.index < step.index ? .forward : .reverse, animated: animated)
                    
                    return step
                case .present(let vc, let animated):
                    guard let vc = vc else { return current }
                    
                    if let self = self, let vc = vc as? PagerContentComponentable {
                        vc.moveTo
                            .observe(on: MainScheduler.asyncInstance)
                            .bind(to: self.moveToRelay)
                            .disposed(by: self.disposeBag)

                        vc.pagerData
                            .observe(on: MainScheduler.asyncInstance)
                            .bind(to: self.pagerDataRelay)
                            .disposed(by: self.disposeBag)
                    }
                    
                    flow.root.present(vc, animated: animated)
                    
                    return current
                case .none:
                    return current
                }
            })
            .distinctUntilChanged({ $0.index == $1.index })
            .bind(to: currentStep)
            .disposed(by: disposeBag)
        
        if pagerMain == nil {
            moveToRelay
                .bind(to: stepper.steps)
                .disposed(by: disposeBag)
        }
        
        stepper.steps.onNext(stepper.initialStep)
    }
}
