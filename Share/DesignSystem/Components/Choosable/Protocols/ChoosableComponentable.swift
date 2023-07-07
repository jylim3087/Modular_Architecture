//
//  ChoosableComponentable.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/26.
//

import RxSwift
import UIKit

public protocol ChoosableComponentable: UIView {
    var isSelected: Bool { set get }
    var isEnabled: Bool { set get }
    
    var isHiddenTitle: Bool  { set get }
    var title: String? { set get }
    
    var font: UIFont { set get }
    
    var select: PublishSubject<ChoosableComponentable> { get }
}
