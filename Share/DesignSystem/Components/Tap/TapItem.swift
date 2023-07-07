//
//  TapItem.swift
//  DabangPro
//
//  Created by 조동현 on 2022/02/22.
//

public struct TapItem: TapItemType, Equatable {
    public var title: String?
    public var subString: String?
    
    init(_ title: String?, _ subString: String? = nil) {
        self.title = title
        self.subString = subString
    }
}
