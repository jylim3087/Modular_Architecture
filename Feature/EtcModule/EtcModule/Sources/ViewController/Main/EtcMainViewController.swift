//
//  EtcMainViewController.swift
//  EtcModule
//
//  Created by 임주영 on 2023/07/14.
//

import UIKit
import Share
import ReactorKit
import Toaster
import RxSwift

public final class EtcMainViewController: UIViewController, ReactorKit.View {
    // MARK: UI
    private let containerView = EctContainerView()
    
    // MARK: PROPERTY
    public var disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.pin.top(view.pin.safeArea).horizontally().bottom()
    }
    
    public func bind(reactor: EtcMainViewReactor) {
        bindState(reactor)
    }
}
extension EtcMainViewController {
    
    private func bindState(_ reactor: EtcMainViewReactor) {
        containerView.bind(reactor: reactor)
        
        reactor.state
            .compactMap { $0.mainMenuAction }
            .bindOnMain { menu in
                switch menu {
                case .contactRoom:
                    Toast(text: "contactroom").show()
                case .untactContract:
                    Toast(text:"untactContract").show()
                case .customerService:
                    Toast(text: "customerService").show()
                }
            }
            .disposed(by: disposeBag)
    }
}
