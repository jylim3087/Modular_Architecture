//
//  PickerViewComponentable.swift
//  DabangPro
//
//  Created by 조동현 on 2023/03/02.
//

import RxSwift
import RxCocoa

protocol PickerViewComponentable {
    var items: [[PickerItemType]] { get set }
    var selectedIndex: [Int] { get set }
    var itemSelected: PublishSubject<[Int]> { get }
}
