//
//  PagerComponentable.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/23.
//

import RxSwift
import RxCocoa
import UIKit

public protocol PagerData {}

protocol PagerMainComponentable: AnyObject {
    var moveTo: PublishRelay<PagerStep> { get }
    var pagerData: BehaviorRelay<PagerData?> { get }
    
    var pagerCoordinator: PagerCoordinator { get }
}

public protocol PagerContentComponentable: UIViewController {
    var moveTo: PublishRelay<PagerStep> { get }
    var pagerData: BehaviorRelay<PagerData?> { get }
}
