//
//  DBErrors.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 2. 28..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit

let DBERROR_ALERT_KEY = "DBERROR_ALERT_IS_SHOW"

public enum DBErrors : Error {
    case ParseError(path: String, line:Int, function: String)
    case FileLoadError(path: String, line:Int, function: String)
    case RequireLoginError(path: String, line:Int, function: String)
    case NotAuthorizeError(path: String, line:Int, function: String)
    case ParameterEncodingError(path: String, line:Int, function: String)
    case NetworkError(api:ST3NetworkServiceAPI?, code:Int, message:String?, data:Any?, path: String, line:Int, function: String)
    case etcError(title: String)
    case alert(title: String, message: String?)

    
}

extension DBErrors {
    public var description : String {
        switch self {
        case .ParseError:
            return "데이터 처리 중 오류가 발생하였습니다."
        case .FileLoadError:
            return "저장 된 데이터를 불러오는 중 오류가 발생하였습니다."
        case .RequireLoginError:
            return "로그인이 필요합니다."
        case .NotAuthorizeError:
            return "해당 기능에 대한 접근 권한이 없습니다."
        case .ParameterEncodingError:
            return "네트워크 통신요청 중 오류가 발생하였습니다."
        case .NetworkError(_, let code, let message, _, _, _, _):
            return message ?? DBNErrorMessages(rawValue: code)?.message ?? "네트워크 상태가 불안정합니다. 연결 상태를 확인해주세요."
        case .etcError(let message):
            return message
        default:
            return ""
        }
    }
    
    public var api: ST3NetworkServiceAPI? {
        switch self {
        case .NetworkError(let api, _, _, _, _, _, _):
            return api
        default:
            return nil
        }
    }
    
    public var localizedDescription: String {
        return self.description
    }
    
    public var needRetry: Bool {
        switch self {
        case .NetworkError(_, let code, _, _, _, _, _):
            return code <= 0 ? true : false
        default:
            return false
        }
    }
    
    public func log() {
        switch self {
        case .ParseError(let path, let line, let function),
             .FileLoadError(let path, let line, let function),
             .RequireLoginError(let path, let line, let function),
             .NotAuthorizeError(let path, let line, let function),
             .ParameterEncodingError(let path, let line, let function):
                DBLog(self.description, path:path, lineNumber:line, function:function)
        case .NetworkError(let api, _, _, _, let path, let line, let function):
                var request : String = "request"
                if let api = api { request = "\(api.basePath)\(api.subPath)" }
                DBLog("\(request):\(description)", path:path, lineNumber:line, function:function)
        case .etcError(let message):
            DBLog(message)
        default:
            break
        }
    }
    
    public func showAlertWithTitle(_ title:String?, path: String = #file, lineNumber: Int = #line, function: String = #function) {
        self.log()
        if !UserDefaults.standard.bool(forKey: DBERROR_ALERT_KEY) {
            UserDefaults.standard.set(true, forKey: DBERROR_ALERT_KEY)
            Alert(title: title, message: self.description).addAction("확인", style: .default, handler: { (_) in UserDefaults.standard.set(false, forKey: DBERROR_ALERT_KEY)})
            .show()
        }
        
    }
    
    static public func parse(path: String = #file, line: Int = #line, function: String = #function) -> DBErrors {
        return DBErrors.ParseError(path: path, line: line, function: function)
    }
    
    static public func fileload(path: String = #file, line: Int = #line, function: String = #function) -> DBErrors {
        return DBErrors.FileLoadError(path: path, line: line, function: function)
    }
    
    static public func requireLogin(path: String = #file, line: Int = #line, function: String = #function) -> DBErrors {
        return DBErrors.RequireLoginError(path: path, line: line, function: function)
    }
    
    static public func parameterEncoding(path: String = #file, line: Int = #line, function: String = #function) -> DBErrors {
        return DBErrors.ParameterEncodingError(path: path, line: line, function: function)
    }
    
    static public func notAuthrized(path: String = #file, line: Int = #line, function: String = #function) -> DBErrors {
        return DBErrors.NotAuthorizeError(path: path, line: line, function: function)
    }
    
    static public func network(api:ST3NetworkServiceAPI?, code: Int, message: String?, data: Any? = nil, path: String = #file, line: Int = #line, function: String = #function) -> DBErrors {
        return DBErrors.NetworkError(api: api, code: code, message: message, data: data, path: path, line: line, function: function)
    }
}

extension DBErrors : Equatable {
    public static func == (lhs:DBErrors, rhs:DBErrors) -> Bool {
        switch lhs {
        case .NetworkError(_, let lCode, let lMessage, _, _, _, _):
            switch rhs {
            case .NetworkError(_, let rCode, let rMessage, _, _, _, _):
                return (lCode == rCode && lMessage == rMessage)
            default:
                return false
            }
        default:
           return (lhs.description == rhs.description)
        }
        
    }
}

enum DBNErrorMessages : Int {
    case NotAuthorized      = 302
    case BadRequest         = 400
    case Unauthorized       = 401
    case PaymentRequired    = 402
    case Forbidden          = 403
    case NotFound           = 404
    case InternalError      = 500
    case NotImplemented     = 501
    case Overloaded         = 502
    case Timeout            = 503
}

extension DBNErrorMessages {
    var message : String {
        switch self {
        case .NotAuthorized:
            return "접근 권한이 없습니다."
        case .BadRequest, .Unauthorized, .PaymentRequired, .Forbidden, .NotFound:
            return "네트워크 요청 중 오류가 발생하였습니다."
        case .InternalError, .NotImplemented, .Overloaded:
            return "네트워크 상태가 불안정합니다. 연결 상태를 확인해주세요."
        case .Timeout:
            return "네트워크 통신이 원활하지 않습니다."
        }
    }
}
