//
//  ButtonComponentable.swift
//  DabangSwift
//
//  Created by 조동현 on 2021/05/13.
//
import UIKit

protocol ButtonComponentable {
    var enableColor: UIColor { get }
    var disableColor: UIColor { get }
    var enableBorderColor: UIColor { get }
    var disableBorderColor: UIColor { get }
}
