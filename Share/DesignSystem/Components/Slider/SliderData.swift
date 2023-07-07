//
//  SliderData.swift
//  DabangSwift
//
//  Created by you dong woo on 2022/08/09.
//

import Foundation

protocol SliderDataRangeProtocol {
    var data: [String] { get }
}

enum SliderDataRange: SliderDataRangeProtocol {
    case regular(start: CGFloat, end: CGFloat, distance: CGFloat, unit: String)
    case irregular(data: [String])
    
    var data: [String] {
        switch self {
        case .regular(let start, let end, let distance, let unit):
            var data: [String] = []
            var mark = start
            
            while mark <= end {
                data.append("\(mark)\(unit)")
                
                mark += distance
            }
            
            return data
            
        case .irregular(let data):
            return data
        }
    }
}

struct OneHandleSliderConfiguration {
    struct SliderIndex {
        let index: Int
    }
    
    let range: SliderDataRange
    let initValue: SliderIndex
}

public struct TwoHandleSliderConfiguration {
    struct SliderIndex {
        let index1: Int
        let index2: Int
    }
    
    let range: SliderDataRange
    let initValue: SliderIndex
}

public enum SliderHandleSlidingRange {
    case range(start: CGFloat, end: CGFloat)
    case unknown
}

public struct SliderMarkData {
    let index: Int
    let percent: CGFloat
    let value: String
}
