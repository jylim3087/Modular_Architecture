//
//  ChipComponentable.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/24.
//

import RxSwift
import UIKit

public protocol ChipComponentable: UIView {
    var text: String? { get set }
    
    var deleteAction: PublishSubject<ChipComponentable> { get }
}

protocol DeletedChipSupportable {}
