//
//  APIResult.swift
//  Share
//
//  Created by 임주영 on 2023/07/07.
//

public struct APIResult<Success: Decodable, Fail> where Fail: Error {
  public let result: Result<Success, Fail>
  
  public var success: Success? {
    guard case .success(let value) = result else { return nil }
    return value
  }
  
  public var fail: Fail? {
    guard case .failure(let error) = result else { return nil }
    return error
  }
  
    public init(result: Result<Success, Fail>) {
    self.result = result
  }
}
