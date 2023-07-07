//
//  ChoosableStyleSupportable.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/26.
//
import UIKit

public protocol ChoosableStyleSupportable {
    associatedtype Status: RawRepresentable where Status.RawValue == Int
    
    var status: Status { get }
    
    var toggleImage: UIImage? { get }
    var textColor: UIColor? { get }
    
    var multiLine: Bool { get }
    
    func status(isSelected: Bool, isEnabled: Bool)
    
    init()
}
