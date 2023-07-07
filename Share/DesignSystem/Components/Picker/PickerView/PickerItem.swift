//
//  PickerItem.swift
//  DabangPro
//
//  Created by 조동현 on 2023/03/02.
//

struct PickerItem: PickerItemType {
    var string: String
    var isEnabled: Bool = true
    
    init(_ string: String, isEnabled: Bool = true) {
        self.string = string
        self.isEnabled = isEnabled
    }
}
