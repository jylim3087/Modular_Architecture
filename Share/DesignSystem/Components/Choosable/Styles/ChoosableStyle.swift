//
//  ChoosableStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2022/01/26.
//

import UIKit

public class ChoosableStyle: ChoosableStyleSupportable {
    public enum Status: Int {
        case enabled
        case selected
        case selectedDisabled
        case disabled
    }
    
    public var status: Status = .enabled
    
    required public init() {}
    
    public func status(isSelected: Bool, isEnabled: Bool) {
        switch (isSelected, isEnabled) {
        case (true, true):      status = .selected
        case (true, false):     status = .selectedDisabled
        case (false, true):     status = .enabled
        case (false, false):    status = .disabled
        }
    }
    
    public var toggleImage: UIImage? {
        return nil
    }
    
    public var textColor: UIColor? {
        switch status {
        case .enabled, .selected: return .gray900
        case .selectedDisabled, .disabled: return .gray400
        }
    }
    
    public var multiLine: Bool {
        return false
    }
}
