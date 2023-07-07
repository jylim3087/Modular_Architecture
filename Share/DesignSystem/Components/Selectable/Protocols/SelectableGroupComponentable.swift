//
//  SelectableGroupComponentable.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/14.
//

import UIKit

public protocol SelectableGroupComponentable: UIView {
    var items: [SelectableGroupItemType] { get set }
    var title: String? { get set }
    var titleDescription: String? { get set }
    var colums: Int { get set }
    var sigleColumType: SelectableComponentable.Type { get }
    var multiColumType: SelectableComponentable.Type { get }
}
