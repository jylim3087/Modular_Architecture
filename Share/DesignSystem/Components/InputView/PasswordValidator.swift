//
//  PasswordValidator.swift
//  test
//
//  Created by Ickhwan Ryu on 2021/08/05.
//

import Foundation
import RxSwift

public class PasswordValidator: TextInputValidatorType {
    
    public var firstText: String? = ""
    
    public enum ValidType: String {
        case pw = "^(?=.*\\d)(?=.*[~`!@#$%\\^&*()-])(?=.*[a-zA-Z]).{8,20}$"
        case configmPw
        
        var msg: String {
            switch self {
            case .pw:
                return "비밀번호는 문자, 숫자, 특수문자를 포함하여 8~20자 이내로 입력하세요"
            case .configmPw:
                return "비밀번호 확인이 동일하지 않습니다."
            }
        }
    }
    
    public func validation(type: ValidType, text: String?) -> Observable<String?> {
        return Observable.create { obs in
            
            switch type {
            case .pw:
                self.firstText = text
                let predicate = NSPredicate(format:"SELF MATCHES %@", type.rawValue)
                
                if !predicate.evaluate(with: text) || text == nil || (text ?? "").isEmpty {
                    obs.onNext(type.msg)
                } else {
                    obs.onNext(nil)
                }
            case .configmPw:
                if self.firstText?.isEmpty ?? true || self.firstText != text  {
                    obs.onNext(type.msg)
                } else {
                    obs.onNext(nil)
                }
            }
            
            return Disposables.create()
        }
    }
}
