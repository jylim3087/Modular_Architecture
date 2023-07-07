//
//  TapComponentable.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/22.
//

import RxSwift
import UIKit

public protocol TapComponentable: UIView {
    var isSelected: Bool { get set }
    var isEnabled: Bool { get set }
    var title: String? { get set }
    
    var tap: PublishSubject<TapComponentable> { get }
}
