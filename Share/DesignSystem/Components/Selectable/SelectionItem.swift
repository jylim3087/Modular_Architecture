//
//  SelectionItem.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/14.
//

public struct SelectionItem: SelectableGroupItemType {
    public var title: String?
    public var isEnabled: Bool = true
    
    init(_ title: String? = nil, isEnabled: Bool = true) {
        self.title = title
        self.isEnabled = isEnabled
    }
}
