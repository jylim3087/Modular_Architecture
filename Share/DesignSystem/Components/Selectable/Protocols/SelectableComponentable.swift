//
//  SelectableComponentable.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/13.
//

import Foundation

import RxSwift
import UIKit

public protocol SelectableComponentable: UIView {
    var isSelected: Bool { set get }
    var isEnabled: Bool { set get }
    var isDelayTouched: Bool { set get }
    
    
    var isHiddenTitle: Bool  { set get }
    var title: String? { set get }
    
    var font: UIFont { set get }
    
    var select: PublishSubject<SelectableComponentable> { get }
    var delayTouchedObs: PublishSubject<(Int, PublishSubject<Bool>)> { get } 
}
