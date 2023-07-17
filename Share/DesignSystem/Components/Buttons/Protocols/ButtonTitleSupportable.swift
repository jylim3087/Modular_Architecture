//
//  ButtonTitleSupportable.swift
//  DabangSwift
//
//  Created by 조동현 on 2021/05/13.
//
import UIKit

protocol ButtonTitleSupportable: UIButton {
    var enableTitleColor: UIColor { get }
    var disableTitleColor: UIColor { get }
    
    func setTitle(_ title: String)
}

extension ButtonTitleSupportable {
    public func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
}
