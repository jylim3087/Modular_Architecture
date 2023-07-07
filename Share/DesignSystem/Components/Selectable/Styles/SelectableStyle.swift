//
//  SelectableStyle.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/14.
//
import UIKit

public class SelectionStyle: SelectableStyleSupportable {
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
    
    public var toggleImage: UIImage? { return nil }
    
    public var textColor: UIColor? {
        switch status {
        case .enabled: return .gray700
        case .selected: return .blue500
        case .selectedDisabled, .disabled: return .gray400
        }
    }
    
    public var backgroundColor: UIColor? {
        switch status {
        case .enabled: return .gray200
        case .selected: return .blue50
        case .selectedDisabled, .disabled: return .gray200
        }
    }
    
    public var borderColor: UIColor? {
        switch status {
        case .enabled, .disabled: return .clear
        case .selected: return .blue500
        case .selectedDisabled: return .gray300
        }
    }
}
