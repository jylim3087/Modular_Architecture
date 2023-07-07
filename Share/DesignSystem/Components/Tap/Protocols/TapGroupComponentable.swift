//
//  TapGroupComponentable.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/22.
//

import RxSwift
import UIKit

public protocol TapGroupComponentable: UIView {
    associatedtype TapItem: TapItemType
    
    var items: [TapItem] { set get }
    var index: Int { set get }
    var isEnabled: Bool { set get }
    var disabledIndexs: [Int] { get set }
    var paddingHorizontal: CGFloat { set get }
    var hiddenBottomDivider: Bool { set get }
    var bottomDividerColor: UIColor { set get }
    var isAutoExtend: Bool { set get }
    
    var itemSelected: PublishSubject<Int> { get }
    var modelSelected: PublishSubject<TapItem> { get }
}

protocol TapGroupMarkSupportable {
    var marks: [Int] { get set }
}
