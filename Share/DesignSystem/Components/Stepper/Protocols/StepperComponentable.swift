//
//  StepperComponentable.swift
//  DabangPro
//
//  Created by 조동현 on 2023/03/07.
//

import RxSwift
import RxCocoa
import UIKit

public protocol StepperComponentable: UIView {
    var value: Int { get set }
    var minValue: Int { get set }
    var maxValue: Int { get set }
    var valueChanged: PublishRelay<Int> { get }
    
    var isEnabled: Bool { get set }
}
