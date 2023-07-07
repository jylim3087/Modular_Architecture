//
//  PickerItemComponentable.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/28.
//

import RxSwift
import RxCocoa
import UIKit

protocol PickerItemComponentable: UIView {
    var title: String? { get set }
    var isSelected: Bool { get set }
    var isEnabled: Bool { get set }
    var textAlignment: NSTextAlignment { get set }
    var tap: PublishSubject<Void> { get }
}
