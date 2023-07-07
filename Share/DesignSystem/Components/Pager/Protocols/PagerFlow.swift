//
//  PagerFlow.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/23.
//

import UIKit

public enum PagerPresentType {
    case navigation(PagerContentComponentable?, animated: Bool = true)
    case present(UIViewController?, animated: Bool = true)
    case none
}

public protocol PagerFlow {
    var root: UIPageViewController { get }
    func navigate(_ step: PagerStep) -> PagerPresentType
}
