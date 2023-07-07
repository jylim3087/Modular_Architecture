//
//  BottomSheetNavigationViewComponentable.swift
//  DabangSwift
//
//  Created by 조동현 on 2022/03/11.
//

import UIKit

public protocol BottomSheetNavigationViewComponentable: UIView {
    var navigationBar: BottomSheetNavigationBar? { get set }
    var navigationController: BottomSheetNavigationController? { get set }
    var fullHeight: Bool { get set }
    
    func present(_ viewController: UIViewController, completion: (() -> Void)?)
    
    func setNavigation(_ nav: BottomSheetNavigationBar)
    func updateView(animated: Bool)
}
