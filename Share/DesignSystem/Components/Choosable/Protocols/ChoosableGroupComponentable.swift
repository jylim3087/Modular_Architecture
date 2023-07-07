//
//  ChoosableGroupComponentable.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/24.
//

import UIKit

public protocol ChoosableGroupComponentable: UIView {
    var items: [ChoosableGroupItemType] { get set }
    var title: String? { get set }
}
