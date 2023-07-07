//
//  URL+Extension.swift
//  Share
//
//  Created by 임주영 on 2023/07/07.
//

import Foundation
import UIKit

extension URL {
    public func open() {
        guard UIApplication.shared.canOpenURL(self) == true else { return }
        
        UIApplication.shared.open(self, options: [:], completionHandler: nil)
    }
    
    public var queryRemovingPercentEncodingDictionary: [String:String] {
        var resultDic = [String:String]()
        let queryArray = self.query?.split(separator: "&") ?? []
        for query in queryArray {
            let keyAndValue = query.split(separator: "=")
            
            guard keyAndValue.count > 1 else { continue }
            
            let key = keyAndValue[0]
            let value = query.replacingOccurrences(of: "\(key)=", with: "")
            
            if let keyDecoding = key.removingPercentEncoding, let valueDecoding = value.removingPercentEncoding {
                resultDic[keyDecoding] = valueDecoding
            }
        }
        return resultDic
    }
    
    public var queryDictionary: [String:String] {
        var resultDic = [String:String]()
        let queryArray = self.query?.split(separator: "&") ?? []
        for query in queryArray {
            let keyAndValue = query.split(separator: "=")
            let key     = keyAndValue[safe: 0]?.removingPercentEncoding ?? ""
            let value   = keyAndValue[safe: 1]?.removingPercentEncoding ?? ""
            resultDic[key] = value
        }
        return resultDic
    }
    
    public func setScheme(_ scheme: String) -> URL {
        guard var urlComps = URLComponents(string: absoluteString) else {
            return self
        }
        
        urlComps.scheme = scheme
        
        if let url = urlComps.url {
            return url
        }
        
        return self
    }
}
