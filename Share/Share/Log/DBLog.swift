//
//  DBLog.swift
//  Share
//
//  Created by 임주영 on 2023/07/07.
//

import Foundation
public func DBLog(_ format: String, _ args: CVarArg..., path: String = #file, lineNumber: Int = #line, function: String = #function) {
    #if DEBUG
    let logs = "\n\n[\(GetFileName(for: path)):\(lineNumber)]" + format
    print(logs)
    #endif
}

private func GetFileName(for path: String) -> String {
    guard let fileName = NSURL(fileURLWithPath: path).lastPathComponent else { return "unknown" }
    return fileName
}
