//
//  SelectableStyleSupportable.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/13.
//

import UIKit

public protocol SelectableStyleSupportable {
    associatedtype Status: RawRepresentable where Status.RawValue == Int
    
    var status: Status { get }
    
    var toggleImage: UIImage? { get }
    var textColor: UIColor? { get }
    
    var backgroundColor: UIColor? { get }
    var borderColor: UIColor? { get }
    
    func status(isSelected: Bool, isEnabled: Bool)
    
    init()
}
