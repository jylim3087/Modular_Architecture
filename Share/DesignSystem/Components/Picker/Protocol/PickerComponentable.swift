//
//  PickerComponentable.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/28.
//

import RxSwift
import RxCocoa
import UIKit

protocol PickerComponentable: UIView {
    var items: [String] { get set }
    var selectedIndex: Int { get set }
    var itemSelected: PublishSubject<Int> { get }
}
