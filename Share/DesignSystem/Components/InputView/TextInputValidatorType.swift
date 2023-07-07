//
//  TextInputValidatorType.swift
//  test
//
//  Created by Ickhwan Ryu on 2021/08/04.
//

import RxSwift

public protocol TextInputValidatorType {
    associatedtype ValidType: RawRepresentable where ValidType.RawValue == String
    
    func validation(type: ValidType, text: String?) -> Observable<String?>
}

public final class EmptyValidatorType: TextInputValidatorType {
    public enum ValidType: String {
        case empty
    }
    
    public func validation(type: ValidType, text: String?) -> Observable<String?> {
        return .just(nil)
    }
}
