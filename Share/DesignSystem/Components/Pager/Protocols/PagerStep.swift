//
//  PagerStep.swift
//  DabangPro
//
//  Created by 조동현 on 2023/02/23.
//

public protocol PagerStep {
    var index: Int { get }
}

public struct NonePagerStep: PagerStep {
    public var index: Int = -1
}
