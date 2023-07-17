//
//  ST3NetworkServiceAPI.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 5. 10..
//  Copyright © 2017년 young-soo park. All rights reserved.         
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import Gloss
import Kingfisher
import Share

#if ServerChange
var baseServer: ST3Server {
    get {
        if let defaultData = ST3Server(rawValue: UserDefaults.standard.integer(forKey: "server")) { return defaultData }
        return .test
    }
    set {
        UserDefaults.standard.set(newValue.rawValue, forKey: "server")
    }
}
#else
var baseServer: ST3Server = .release
#endif

var ST3ServerPath = baseServer.url

var ST3TermsServerPath = "https://main.d3qjzrynlab66o.amplifyapp.com"
var ST3ImageServerPath = baseServer == .test ? "https://s3-ap-northeast-1.amazonaws.com/dabang-dev-image" : "http://images.dabangapp.com"
var ST3ImageUploadServerPath = "https://upload-images.dabangapp.com"
var ST3WebBasePath = baseServer.web
//
var apiMetaData: [String: Any] = {
    var param: [String: Any] = [:]

    param["api_version"] = "3.0.1"
    param["call_type"] = "ios"
//    param["app_version"] = VersionUtil.appVersion
//    param["uuid"] = UUIDWrapper.shared.uuid

    return param
}()



struct BasicPayload: Decodable {}

extension Decodable {
    init(decoder:JSONDecoder, jsonData:Data) throws {
        self = try decoder.decode(Self.self, from: jsonData)
    }
}

private let backgroundQueue = DispatchQueue.global()

extension ST3NetworkServiceAPI {
//    var baseURL     : String { return ST3ServerPath + "/api/3" }
//    var getFullPath : String { return self.baseURL + self.basePath + self.subPath }
//    var decoder     : JSONDecoder { return JSONDecoder() }
//    var respType    : Decodable.Type { return BasicPayload.self }
//    var body        : [String: Any?]? { return nil }
//    var headers     : [String: String]? { return nil }
//    var noTrace     : Bool { return false }
//    var bodyData    : Data? { return nil }
    
    func modifyParameters(authKey:String? = nil) -> [String: Any] {
        var modifiedParam : [String:Any] = Dictionary()
        
        if let authKey = authKey { modifiedParam.updateValue(authKey, forKey: "auth_key") }
        
        if let parameters = self.parameters {
            let keys = parameters.keys
            for key in keys {
                if let value = parameters[key]! as Any? { modifiedParam.updateValue(value, forKey: key) }
            }
        }
        
        apiMetaData.forEach { key, value in
            modifiedParam[key] = value
        }
        
        return modifiedParam
    }

    // MARK: -------- gloss, No promise
    
    func request<R:JSONDecodable>(_ type: R.Type, token: String? = nil) -> Single<R> {
        guard NetworkFlow.unusableNetwork == false else { return .never() }
        
        return Single.create { single in
            var authKey: String? = nil
            
            if let reachability = NetworkManager.shared.reachability, !reachability.isReachable {
                single(.failure(DBErrors.network(api:nil, code:-10000, message:nil)))
                return Disposables.create()
            }
            
            if let tk = token { authKey = tk }
            //else if let tk = appStore.state.user.authKey { authKey = tk }
            
            if self.isRequireToken == .essential && authKey == nil {
                single(.failure(DBErrors.requireLogin()))
                return Disposables.create()
            }
            
            let parameters = self.modifyParameters(authKey: (self.isRequireToken == .no) ? nil : authKey)
            
            if self.method != .multipart {
                self.request(type, single: single, parameters: parameters)
            } else {
                self.upload(single, parameters: parameters)
            }
            
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
        .catch({ error in
            if let error = error as? DBErrors,
                NetworkFlowManager.current.checkNetworkTypeError(error: error) == false {
                return .never()
            }
            
            return .error(error)
        })
        .retryWhen()
    }
    
    private func request<R: JSONDecodable>(_ type: R.Type, single: @escaping (SingleEvent<R>) -> Void, parameters:[String:Any]) {
        removeCookies()
        
        let method = HTTPMethod(rawValue: self.method.rawValue)
        let bodyEncoder = BodyParamEncoder(api: self)
        
        if self.noTrace {
            safeRequest(type, single: single, parameters: parameters)
            return
        }
        
        AF.request(self.getFullPath, method: method, parameters: parameters, encoding: bodyEncoder)
            .validate(statusCode: 200..<300)
            .responseJSON(queue: backgroundQueue, options: .mutableContainers) { response in
                self.handleResponse(response: response, single: single)
            }
    }
    
    private func upload<R: JSONDecodable>(_ single: @escaping (SingleEvent<R>) -> Void, parameters:[String:Any]) {
        AF.upload(multipartFormData: { (multipartFormData) in
            for key in parameters.keys {
                if let item = parameters[key] as? String, let data = item.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                } else if let item = parameters[key] as? UIImage, let data = item.jpegData(compressionQuality: 1.0) {
                    multipartFormData.append(data, withName: "file", fileName: key, mimeType: "image/jpeg")
                }
            }
        }, to: self.getFullPath)
        .validate(statusCode: 200..<300)
        .responseData(completionHandler: { response in
            let newResult = response.result.map { data in
                return data as Any
            }
            
            let newResponse = DataResponse(request: response.request,
                                        response: response.response,
                                        data: response.data,
                                        metrics: response.metrics,
                                        serializationDuration: response.serializationDuration,
                                        result: newResult)
            
            self.handleResponse(response: newResponse, single: single)
        })
    }
    
    private func handleResponse<R:JSONDecodable>(response: AFDataResponse<Any>, single: (SingleEvent<R>) -> Void) {
        print("url: \(response.request?.url)")
        guard let code = response.response?.statusCode else {
            let httpErrorCode = response.result.httpErrorCode ?? -100
            single(.failure(DBErrors.network(api:nil, code:httpErrorCode, message:nil))); return
        }
        
        switch response.result {
        case .success(let value):
            if let jsonDict = self.responseToNSDictionary(response: value) {
                if let json = jsonDict as? JSON, let data = R.init(json: json) {
                    single(.success(data))
                    return
                }
            }
                
            if (value as? Data) != nil {
                single(.success(R.init(json: [:])!))
                return
            }
            
            single(.failure(DBErrors.parse()))
        case .failure:
            var msg : String? = nil
            var errorData: Any? = nil
            
            if let data = response.data,
                let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                msg = jsonDict["msg"] as? String? ?? nil
                
                if code == 416,
                   let model = try? JSONDecoder().decode(NetworkMaintainanceModel.self, from: data) {
                    errorData = model
                }
            }
            
            single(.failure(DBErrors.network(api:self, code:code, message: msg, data: errorData)))
        }
    }
  
  // MARK: ReactorKit Request
  
  func request<T: Decodable>(type: T.Type, token: String? = nil) -> Observable<APIResult<T, Error>> {
    guard NetworkFlow.unusableNetwork == false else { return .never() }
      
    return Single.create { single in
        var authKey: String? = nil

        if let reachability = NetworkManager.shared.reachability, !reachability.isReachable {
        single(.success(APIResult(result: .failure(DBErrors.network(api:nil, code:-10000, message:nil)))))
        return Disposables.create()
        }

        if let tk = token { authKey = tk }
        //else if let tk = appStore.state.user.authKey { authKey = tk }

        if self.isRequireToken == .essential && authKey == nil {
        single(.success(APIResult(result: .failure(DBErrors.requireLogin()))))
        return Disposables.create()
        }

        let parameters = self.modifyParameters(authKey: (self.isRequireToken == .no) ? nil : authKey)

        if self.method != .multipart {
            self.request2(type, single: single, parameters: parameters)
            
        } else {
            self.upload2(single, parameters: parameters)
        }

        return Disposables.create()
    }
    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
    .catch({ error in
        if let error = error as? DBErrors,
            NetworkFlowManager.current.checkNetworkTypeError(error: error) == false {
            return .never()
        }
        
        return .just(APIResult(result: .failure(error)))
    })
    .retryWhen()
    .asObservable()
    .do(onNext: { response in
        switch response.result {
        case .success: break
        case .failure(let error):
            guard let error = error as? DBErrors else { return }
            
            switch error {
            case .NetworkError(_, let code, _, _, _, _, _):
                if code == 302 {
                    //UserLoader.logout()
                    //TransitionManager.shared().action(.goToHome)
                }
                
            default: break
            }
            
            print()
            
        }
    })
  }

    
    private func request2<T: Decodable>(_ type: T.Type, single: @escaping (SingleEvent<APIResult<T,Error>>) -> Void, parameters:[String:Any]) {
        removeCookies()

        let method = HTTPMethod(rawValue: self.method.rawValue)
        let bodyEncoder = BodyParamEncoder(api: self)

        let headers = self.headers == nil ? nil : HTTPHeaders(self.headers!)

        AF.request(self.getFullPath, method: method, parameters: parameters, encoding: bodyEncoder, headers: headers)
        .validate(statusCode: 200..<300)
        .responseJSON(queue: backgroundQueue, options: .mutableContainers) { response in
            self.handleResponse2(response: response, single: single)
        }
    }
    
    private func upload2<T: Decodable>(_ single: @escaping (SingleEvent<APIResult<T,Error>>) -> Void, parameters:[String:Any]) {
        AF.upload(multipartFormData: { (multipartFormData) in
            for key in parameters.keys {
                if let item = parameters[key] as? String, let data = item.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                } else if let item = parameters[key] as? UIImage, let data = item.jpegData(compressionQuality: 1.0) {
                    multipartFormData.append(data, withName: "file", fileName: key, mimeType: "image/jpeg")
                }
            }
        }, to: self.getFullPath)
        .validate(statusCode: 200..<300)
        .responseData(completionHandler: { response in
            let newResult = response.result.map { data -> Any in
                let dataStr = String(decoding: data, as: UTF8.self)
                
                if dataStr == "OK" {
                    return ([] as [String]) as Any
                }
                
                if let newData = try? JSONSerialization.jsonObject(with: data) {
                    return newData as Any
                }
                
                return data as Any
            }
            
            let newResponse = DataResponse(request: response.request,
                                        response: response.response,
                                        data: response.data,
                                        metrics: response.metrics,
                                        serializationDuration: response.serializationDuration,
                                        result: newResult)
            
            self.handleResponse2(response: newResponse, single: single)
        })
    }
  
  private func handleResponse2<T:Decodable>(response: AFDataResponse<Any>, single: (SingleEvent<APIResult<T,Error>>) -> Void) {
      print("url: \(response.request?.url)")
      guard let code = response.response?.statusCode else {
        let httpErrorCode = response.result.httpErrorCode ?? -100
        single(.success(APIResult(result: .failure(DBErrors.network(api:nil, code:httpErrorCode, message:nil))))); return
      }
      
      switch response.result {
      case .success(let value):
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
            let model = try JSONDecoder().decode(T.self, from: jsonData)
            single(.success(APIResult(result: .success(model))))
            return
        } catch {
            single(.failure(DBErrors.parse())); return
        }
        
      case .failure:
          var msg : String? = nil
          var errorData: Any? = nil
        
          if let data = response.data,
             let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
              msg = jsonDict["msg"] as? String? ?? nil
              
              if code == 416,
                 let model = try? JSONDecoder().decode(NetworkMaintainanceModel.self, from: data) {
                  errorData = model
              }
          }
        
          single(.failure(DBErrors.network(api:self, code:code, message:msg, data: errorData)))
      }
  }
    
    private func responseToNSDictionary(response: Any) -> NSDictionary? {
        switch response {
        case let dictionary as [String:Any]:
            DBLog("response is dictionary type")
            return dictionary as NSDictionary
        case let array as [Any]:
            DBLog("response is array type")
            return NSDictionary(object: array, forKey: "items" as NSString)
        default:
            DBLog("response is unknown type \(response)")
            return nil
        }
    }
    
    private func removeCookies() {
        guard let cookies = HTTPCookieStorage.shared.cookies else {
            return
        }
        
//        for cookie in cookies {
//            let host = ST3ServerPath.replacingOccurrences(of: "https://", with: "")
//            if cookie.domain == host {
//                HTTPCookieStorage.shared.deleteCookie(cookie)
//                return
//            }
//        }
    }
    
    private func safeRequest<R: JSONDecodable>(_ type: R.Type, single: @escaping (SingleEvent<R>) -> Void, parameters:[String:Any]) {
        func query(_ parameters: [String: Any]) -> String {
            var components: [(String, String)] = []

            for key in parameters.keys.sorted(by: <) {
                let value = parameters[key]!
                components += URLEncoding().queryComponents(fromKey: key, value: value)
            }
            return components.map { "\($0)=\($1)" }.joined(separator: "&")
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCredentialStorage = nil
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringCacheData

        let s = URLSession(configuration: configuration)

        guard let url = URL(string: self.getFullPath) else { return }
        guard var request = try? URLRequest(url: url, method: .post) else { return }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let percentEncodingQuery = urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "" + query(parameters)
            urlComponents.percentEncodedQuery = percentEncodingQuery
            request.url = urlComponents.url
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = self.bodyData

        s.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error as? URLError {
                single(.failure(DBErrors.network(api:nil, code: error.errorCode, message:nil)))
                return
            }

            let response = response as? HTTPURLResponse
            guard let data = data, let response = response, (200..<300).contains(response.statusCode) else {
                var msg : String? = nil
                let code = response!.statusCode

                if let data = data,
                    let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    msg = jsonDict["msg"] as? String
                }

                single(.failure(DBErrors.network(api:self, code:code, message: msg)))
                return
            }

            guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else {
                single(.failure(DBErrors.parse()))
                return
            }

            if let json = jsonToArray as? JSON, let data = R.init(json: json) {
                single(.success(data))
                return
            }
        })
        .resume()

        return
    }
}
struct BodyParamEncoder: ParameterEncoding {
    var api : ST3NetworkServiceAPI
    
    init(api: ST3NetworkServiceAPI) {
        self.api = api
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        guard var request = try? urlRequest.asURLRequest() else { throw DBErrors.parameterEncoding() }
        request.timeoutInterval = 20
        
        var parameters = parameters
        
        if api.method == .post {
            apiMetaData.forEach { key, value in
                parameters?[key] = nil
            }
        }
        
        if let url = URL(string: api.getFullPath), var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let percentEncodingQuery = urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "" + query(parameters!)
            urlComponents.percentEncodedQuery = percentEncodingQuery
            request.url = urlComponents.url
        }
        
        if request.httpMethod == HTTPMethod.post.rawValue {
            let body = api.body ?? [:]
            var newBodyParam: [String: Any] = apiMetaData
            let keys = body.keys
            for key in keys {
                if let value = body[key]! as Any? { newBodyParam.updateValue(value, forKey: key) }
            }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: newBodyParam, options: .prettyPrinted) else { throw DBErrors.parameterEncoding() }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
        }
        
        return request
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += URLEncoding().queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
}
