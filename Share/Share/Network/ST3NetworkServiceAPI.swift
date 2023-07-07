//
//  ST3NetworkServiceAPI.swift
//  Share
//
//  Created by 임주영 on 2023/07/07.
//

import Foundation

public protocol ST3NetworkServiceAPI {
    var baseURL         : String { get }
    var basePath        : String { get }
    var subPath         : String { get }
    var method          : ST3HttpMethod { get }
    var body            : [String: Any?]? { get }
    var parameters      : [String: Any?]? { get }
    var isRequireToken  : TokenSetType { get }
    var getFullPath     : String { get }
    var decoder         : JSONDecoder { get }
    var respType        : Decodable.Type { get }
    var headers         : [String: String]? { get }
    var noTrace         : Bool { get }
    var bodyData        : Data? { get }
}

public enum TokenSetType {
    case essential
    case optional
    case no
}

public enum ST3HttpMethod : String {
    case options    = "OPTIONS"
    case get        = "GET"
    case head       = "HEAD"
    case post       = "POST"
    case put        = "PUT"
    case patch      = "PATCH"
    case delete     = "DELETE"
    case trace      = "TRACE"
    case connect    = "CONNECT"
    case multipart  = "MULTIPART"
}

extension ST3HttpMethod : Equatable {
    public static func == (lhs:ST3HttpMethod, rhs:ST3HttpMethod) -> Bool {
        return (lhs.rawValue == rhs.rawValue)
    }
}
